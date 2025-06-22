import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
// import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geoportal_mobile/models/data_umum_model.dart';
import 'package:geoportal_mobile/models/data_spasial_model.dart';
import 'package:geoportal_mobile/models/log_konfirmasi_model.dart';

class TambahDataController {
  // Text Controllers
  final TextEditingController lokasiController;
  final TextEditingController kelurahanController;
  final TextEditingController kecamatanController;
  final TextEditingController kawasanController;
  final TextEditingController alamatController;
  final TextEditingController rtController;
  final TextEditingController rwController;
  final TextEditingController panjangBentukController;
  final TextEditingController luasBentukController;
  final TextEditingController titikKoordinatController;

  final GlobalKey<FormState> formKey;

  TambahDataController({
    required this.titikKoordinatController,
    required this.lokasiController,
    required this.kelurahanController,
    required this.kecamatanController,
    required this.kawasanController,
    required this.alamatController,
    required this.rtController,
    required this.rwController,
    required this.panjangBentukController,
    required this.luasBentukController,
    required this.formKey,
  });

  final List<File> _fotoFiles = [];
  final List<String> _fotoUrls = [];
  bool _isUploading = false;
  bool isLoading = false;

  List<File> get fotoFiles => _fotoFiles;
  List<String> get fotoUrls => _fotoUrls;
  bool get isUploading => _isUploading;

  // Memilih foto dari galeri
  Future<void> pilihFoto(BuildContext context) async {
    if (_fotoFiles.length >= 3) {
      showCustomSnackbar(
        context: context,
        message: 'Maksimal 3 foto yang diupload',
        isSuccess: false,
      );
      return;
    }

    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final extension = pickedFile.path.split('.').last.toLowerCase();

        if (!['jpg', 'jpeg', 'png'].contains(extension)) {
          showCustomSnackbar(
            context: context,
            message: 'Format file harus JPG, JPEG, atau PNG',
            isSuccess: false,
          );
          return;
        }

        _fotoFiles.add(file);
      }
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'Gagal memilih foto: $e',
        isSuccess: false,
      );
    }
  }

  // Menghapus foto berdasarkan index
  void hapusFoto(int index) {
    if (index >= 0 && index < _fotoFiles.length) {
      _fotoFiles.removeAt(index);
    }
  }

  // Upload foto ke Supabase dan mengembalikan URL publik
  Future<List<String>> uploadFoto() async {
    _isUploading = true;
    _fotoUrls.clear();

    final supabase = Supabase.instance.client;
    final bucket = supabase.storage.from('images');

    try {
      for (final file in _fotoFiles) {
        final fileName =
            'foto_lokasi/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final fileBytes = await file.readAsBytes();

        await bucket.uploadBinary(
          fileName,
          fileBytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );

        final url = bucket.getPublicUrl(fileName);
        _fotoUrls.add(url);
      }
      return _fotoUrls;
    } catch (e) {
      throw Exception('Gagal upload foto: $e');
    } finally {
      _isUploading = false;
    }
  }

  Future<void> simpanData(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      // Upload foto jika ada
      if (_fotoFiles.isNotEmpty) {
        await uploadFoto();
      }

      // Ambil user saat ini
      final currentUser = FirebaseAuth.instance.currentUser;
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser!.uid)
          .get();

      final dataUser = userDoc.data();
      final role = dataUser?['peran']?.toString().toLowerCase() ?? '';
      final bool isAdmin = role == 'admin';

      // Simpan data spasial
      final dataSpasial = DataSpasialModel(
        titikKoordinat: titikKoordinatController.text,
        status: isAdmin ? 'disetujui' : 'menunggu',
        createdAt: DateTime.now(),
      );

      final docSpasial = await FirebaseFirestore.instance
          .collection('data_spasial')
          .add(dataSpasial.toMap());

      // Simpan data umum
      final docUmum = FirebaseFirestore.instance.collection('data_umum').doc();

      final dataUmum = DataUmumModel(
        id: docUmum.id,
        namaLokasi: lokasiController.text,
        kelurahan: kelurahanController.text,
        kecamatan: kecamatanController.text,
        kawasan: kawasanController.text,
        alamat: alamatController.text,
        rt: rtController.text,
        rw: rwController.text,
        panjangBentuk: panjangBentukController.text,
        luasBentuk: luasBentukController.text,
        fotoLokasi: _fotoUrls,
        idDataSpasial: docSpasial.id,
        createdAt: DateTime.now(),
      );

      await docUmum.set(dataUmum.toMap());

      // Jika bukan admin, buat log konfirmasi
      if (!isAdmin) {
        final log = LogKonfirmasiModel(
          uid: currentUser.uid,
          nama: dataUser?['nama'] ?? '',
          peran: role,
          deskripsi: 'Permintaan Konfirmasi Data',
          status: 'menunggu',
          timestamp: Timestamp.now(),
          data: {
            'id_data_umum': docUmum.id,
            'id_data_spasial': docSpasial.id,
          },
        );

        await FirebaseFirestore.instance
            .collection('log_konfirmasi')
            .add(log.toMap());
      }

      // Notifikasi
      showCustomSnackbar(
        context: context,
        message:
            'Data berhasil diajukan${isAdmin ? '' : ' untuk dikonfirmasi'}',
        isSuccess: true,
      );
      Navigator.pop(context);
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'Gagal menyimpan data: $e',
        isSuccess: false,
      );
    }
  }

  // // Memilih tanggal publikasi
  // Future<void> selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //     locale: const Locale('id'),
  //   );

  //   if (pickedDate != null) {
  //     publikasiController.text =
  //         DateFormat('dd MMMM yyyy', 'id').format(pickedDate);
  //   }
  // }

  // Dispose semua controller
  void dispose() {
    lokasiController.dispose();
    kelurahanController.dispose();
    kecamatanController.dispose();
    alamatController.dispose();
    rtController.dispose();
    rwController.dispose();
    panjangBentukController.dispose();
    luasBentukController.dispose();
    titikKoordinatController.dispose();
  }
}
