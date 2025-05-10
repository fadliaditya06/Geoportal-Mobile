import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:convert';

class RegisterController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kataSandiController = TextEditingController();
  final TextEditingController konfirmasiKataSandiController = TextEditingController();

  String? selectedRole;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> register(BuildContext context) async {
    try {
      // Validasi input
      final validationError = _validateInputs(context);
      if (validationError != null) {
        _showSnackbar(context, validationError);
        return;
      }

      // Buat akun dengan Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: kataSandiController.text.trim(),
      );

      // Simpan data tambahan ke Firestore
      await _storeUserData(userCredential.user!);

      // ignore: use_build_context_synchronously
      // Fungsi untuk menampilkan snackbar dengan pesan sukses
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Berhasil',
          message: 'Pendaftaran akun berhasil!',
          contentType: ContentType.success,
        ),
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // _showSnackbar(context, 'Pendaftaran berhasil!');
      clearForm();

      // Navigasi ke halaman login setelah registrasi berhasil
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamed('/login');
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      _handleAuthError(context, e);
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showSnackbar(context, 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  String? _validateInputs(BuildContext context) {
    // Validasi untuk semua form harus diisi
    if (emailController.text.isEmpty ||
        namaController.text.isEmpty ||
        alamatController.text.isEmpty ||
        kataSandiController.text.isEmpty ||
        konfirmasiKataSandiController.text.isEmpty) {
      return 'Semua form harus diisi';
    }
    return null;
  }

  Future<void> _storeUserData(User user) async {
    // Hash kata sandi menggunakan SHA-256
    final hashedKataSandi =
        sha256.convert(utf8.encode(kataSandiController.text.trim())).toString();
    // Simpan data pengguna ke Firestore
    await _firestore.collection('user').doc(user.uid).set({
      'uid': user.uid,
      'email': emailController.text.trim(),
      'nama': namaController.text.trim(),
      'alamat': alamatController.text.trim(),
      'peran': selectedRole,
      'foto_profil': '',
      'kata_sandi': hashedKataSandi,
      // 'emailVerified': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void _handleAuthError(BuildContext context, FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'Email ini sudah terdaftar!';
        break;
      default:
        errorMessage = 'Terjadi kesalahan: ${e.message}';
    }
    _showSnackbarError (context, errorMessage);
  }
  // Fungsi untuk menampilkan snackbar dengan pesan kesalahan
  void _showSnackbarError(BuildContext context, String message) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Gagal',
      message: message,
      contentType: ContentType.failure,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
  void clearForm() {
    emailController.clear();
    namaController.clear();
    alamatController.clear();
    kataSandiController.clear();
    konfirmasiKataSandiController.clear();
    selectedRole = null;
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void dispose() {
    emailController.dispose();
    namaController.dispose();
    alamatController.dispose();
    kataSandiController.dispose();
    konfirmasiKataSandiController.dispose();
  }
}
