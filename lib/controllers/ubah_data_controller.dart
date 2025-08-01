import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'package:geoportal_mobile/models/log_konfirmasi_model.dart';
import 'package:geoportal_mobile/services/performance_tracer.dart';
import 'package:geoportal_mobile/services/firebase_performance_tracer.dart';

class UbahDataController extends GetxController {
  final GlobalKey<FormState> formKey;
  final isLoading = false.obs;

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final SupabaseClient supabase;
  final StorageFileApi storage;
  final PerformanceTracer tracer;

  UbahDataController({
    GlobalKey<FormState>? formKey,
    required this.auth,
    required this.firestore,
    required this.supabase,
    required this.storage,
    PerformanceTracer? tracer,
  }) : formKey = formKey ?? GlobalKey<FormState>(),
       tracer = tracer ?? FirebasePerformanceTracer('trace_ubah_data');

  // Form input controllers
  final kelurahanController = TextEditingController();
  final kecamatanController = TextEditingController();
  final kawasanController = TextEditingController();
  final lokasiController = TextEditingController();
  final alamatController = TextEditingController();
  final rtController = TextEditingController();
  final rwController = TextEditingController();
  final panjangBentukController = TextEditingController();
  final luasBentukController = TextEditingController();
  final titikKoordinatController = TextEditingController();

  // Foto baru dari galeri
  List<File> fotoFiles = [];

  // Foto lama dari URL (misalnya dari database)
  List<String> fotoUrls = [];

  // Inisialisasi data dari Firestore / BottomSheet
  void initWithData(Map<String, dynamic> data) {
    lokasiController.text = data['nama_lokasi'] ?? '';
    kelurahanController.text = data['kelurahan'] ?? '';
    kecamatanController.text = data['kecamatan'] ?? '';
    kawasanController.text = data['kawasan'] ?? '';
    alamatController.text = data['alamat'] ?? '';
    rtController.text = data['rt'] ?? '';
    rwController.text = data['rw'] ?? '';
    panjangBentukController.text = data['panjang_bentuk'] ?? '';
    luasBentukController.text = data['luas_bentuk'] ?? '';
    titikKoordinatController.text = data['titik_koordinat'] ?? '';

    // Ambil foto yang sudah ada
    if (data['foto_lokasi'] is String) {
      fotoUrls = [data['foto_lokasi']];
    } else if (data['foto_lokasi'] is List) {
      fotoUrls = List<String>.from(data['foto_lokasi']);
    }
  }

  // Menambahkan satu foto dari galeri (tanpa preview popup)
  Future<void> pilihFoto(BuildContext context) async {
    final picker = ImagePicker();

    if (fotoUrls.length + fotoFiles.length >= 3) {
      showCustomSnackbar(
        context: context,
        message: 'Maksimal 3 foto dapat dipilih',
        isSuccess: false,
      );
      return;
    }

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final ext = pickedFile.path.split('.').last.toLowerCase();

        if (!['jpg', 'jpeg', 'png'].contains(ext)) {
          showCustomSnackbar(
            context: context,
            message: 'Format file harus JPG, JPEG, atau PNG',
            isSuccess: false,
          );
          return;
        }

        fotoFiles.add(file);
      }
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'Gagal memilih foto: $e',
        isSuccess: false,
      );
    }
  }

  // Menghapus foto lama
  void hapusFotoLama(int index) {
    if (index >= 0 && index < fotoUrls.length) {
      fotoUrls.removeAt(index);
    }
  }

  // Menghapus foto baru
  void hapusFotoBaru(int index) {
    if (index >= 0 && index < fotoFiles.length) {
      fotoFiles.removeAt(index);
    }
  }

  // Upload foto baru ke Supabase
  Future<List<String>> uploadFotoBaru() async {
    final List<String> uploadedUrls = [];

    for (final file in fotoFiles) {
      final fileName =
          'foto_lokasi/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final bytes = await file.readAsBytes();

      await storage.uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );

      final url = storage.getPublicUrl(fileName);
      uploadedUrls.add(url);
    }

    return uploadedUrls;
  }

  // Simpan perubahan ke Firestore
  Future<void> simpanPerubahan(
    String idDataUmum,
    String idDataSpasial,
    BuildContext context, {
    bool isLoadTest = false,
  }) async {
    await tracer.start();
    final stopwatch = Stopwatch()..start();

    if (!isTestMode && formKey.currentState?.validate() == false) {
      return;
    }

    try {
      isLoading.value = true;

      // Upload foto baru (jika ada)
      List<String> uploadedUrls = [];
      if (fotoFiles.isNotEmpty) {
        uploadedUrls = await uploadFotoBaru();
      }

      final allFotoUrls = [...fotoUrls, ...uploadedUrls];

      // Ambil data user dan peran
      final currentUser = auth.currentUser;
      final userDoc =
          await firestore.collection('user').doc(currentUser!.uid).get();
      final dataUser = userDoc.data();
      final role = dataUser?['peran']?.toString().toLowerCase() ?? '';
      final isAdmin = role == 'admin';

      // tracer.putAttribute("user_role", role);
      // tracer.incrementMetric("foto_baru_count", fotoFiles.length);

      if (isAdmin) {
        // Role admin update tanpa konfirmasi
        await firestore.collection('data_spasial').doc(idDataSpasial).update({
          'titik_koordinat': titikKoordinatController.text,
          'status': 'disetujui',
          'updated_at': DateTime.now(),
        });

        await firestore.collection('data_umum').doc(idDataUmum).update({
          'nama_lokasi': lokasiController.text,
          'kelurahan': kelurahanController.text,
          'kecamatan': kecamatanController.text,
          'kawasan': kawasanController.text,
          'alamat': alamatController.text,
          'rt': rtController.text,
          'rw': rwController.text,
          'panjang_bentuk': panjangBentukController.text,
          'luas_bentuk': luasBentukController.text,
          'foto_lokasi': allFotoUrls,
          'updated_at': DateTime.now(),
        });

        if (!isLoadTest && context.mounted) {
          showCustomSnackbar(
            context: context,
            message: 'Data berhasil diubah oleh admin',
            isSuccess: true,
          );
          Navigator.pop(context);
        }
      } else {
        // Role pengguna update memerlukan konfirmasi
        final log = LogKonfirmasiModel(
          uid: currentUser.uid,
          nama: dataUser?['nama'] ?? '',
          peran: role,
          deskripsi: 'Permintaan Konfirmasi Ubah Data',
          status: 'menunggu',
          timestamp: Timestamp.now(),
          data: {'id_data_umum': idDataUmum, 'id_data_spasial': idDataSpasial},
          dataBaru: {
            'nama_lokasi': lokasiController.text,
            'kelurahan': kelurahanController.text,
            'kecamatan': kecamatanController.text,
            'kawasan': kawasanController.text,
            'alamat': alamatController.text,
            'rt': rtController.text,
            'rw': rwController.text,
            'panjang_bentuk': panjangBentukController.text,
            'luas_bentuk': luasBentukController.text,
            'foto_lokasi': allFotoUrls,
            'titik_koordinat': titikKoordinatController.text,
          },
        );

        await firestore.collection('log_konfirmasi').add(log.toMap());

        if (!isLoadTest && context.mounted) {
          showCustomSnackbar(
            context: context,
            message: 'Permintaan ubah data berhasil diajukan',
            isSuccess: true,
          );
          Navigator.pop(context);
        }
      }

      stopwatch.stop();
      print(
        'User ${auth.currentUser?.uid} waktu simpanPerubahan(): ${stopwatch.elapsedMilliseconds} ms',
      );
      await tracer.stop();
    } catch (e) {
      // tracer.incrementMetric("error", 1);
      if (!isLoadTest && context.mounted) {
        showCustomSnackbar(
          context: context,
          message: 'Gagal mengubah data: $e',
          isSuccess: false,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    kelurahanController.dispose();
    kecamatanController.dispose();
    kawasanController.dispose();
    lokasiController.dispose();
    alamatController.dispose();
    rtController.dispose();
    rwController.dispose();
    panjangBentukController.dispose();
    luasBentukController.dispose();
    titikKoordinatController.dispose();
    super.dispose();
  }
}
