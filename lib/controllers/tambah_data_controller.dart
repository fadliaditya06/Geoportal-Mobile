import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class TambahDataController {
  final TextEditingController namaLokasiController = TextEditingController();
  final TextEditingController pemilikController = TextEditingController();
  final TextEditingController publikasiController = TextEditingController();
  final TextEditingController jenisSumberDayaController =
      TextEditingController();
  final TextEditingController sumberController = TextEditingController();
  final TextEditingController sistemProyeksiController =
      TextEditingController();
  final TextEditingController titikKoordinatController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  // Simpan data ke Firebase Firestore
  Future<void> simpanData(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        if (_fotoFiles.isNotEmpty) {
          await uploadFoto();
        }

        final docSpasial =
            await FirebaseFirestore.instance.collection('data_spasial').add({
          'sistem_proyeksi': sistemProyeksiController.text,
          'titik_koordinat': titikKoordinatController.text,
          'createdAt': Timestamp.now(),
        });

        final docUmum =
            FirebaseFirestore.instance.collection('data_umum').doc();

        await docUmum.set({
          'id_data_umum': docUmum.id, 
          'nama_lokasi': namaLokasiController.text,
          'pemilik': pemilikController.text,
          'publikasi': publikasiController.text,
          'jenis_sumber_daya': jenisSumberDayaController.text,
          'sumber': sumberController.text,
          'foto_lokasi': _fotoUrls,
          'id_data_spasial': docSpasial.id,
          'createdAt': Timestamp.now(),
        });

        showCustomSnackbar(
          context: context,
          message: 'Data berhasil disimpan',
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
  }

  // Memilih tanggal publikasi
  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('id'),
    );

    if (pickedDate != null) {
      publikasiController.text =
          DateFormat('dd MMMM yyyy', 'id').format(pickedDate);
    }
  }

  // Dispose semua controller
  void dispose() {
    namaLokasiController.dispose();
    pemilikController.dispose();
    publikasiController.dispose();
    jenisSumberDayaController.dispose();
    sumberController.dispose();
    sistemProyeksiController.dispose();
    titikKoordinatController.dispose();
  }
}
