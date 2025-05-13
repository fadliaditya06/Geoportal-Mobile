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
      // Buat akun dengan Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: kataSandiController.text.trim(),
      );

      // Simpan data ke Firestore
      await _storeUserData(userCredential.user!);

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

  // Fungsi untuk menyimpan data user ke Firestore
  Future<void> _storeUserData(User user) async {
    // Hash kata sandi menggunakan SHA-256
    final hashedKataSandi =
        sha256.convert(utf8.encode(kataSandiController.text.trim())).toString();
    // Data user yang akan disimpan
    await _firestore.collection('user').doc(user.uid).set({
      'uid': user.uid,
      'email': emailController.text.trim(),
      'nama': namaController.text.trim(),
      'alamat': alamatController.text.trim(),
      'peran': selectedRole,
      'foto_profil': '',
      'kata_sandi': hashedKataSandi,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Fungsi untuk menangani kesalahan autentikasi dan menampilkan snackbar
  void _handleAuthError(BuildContext context, FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'Email ini sudah terdaftar!';
        break;
      default:
        errorMessage = 'Terjadi kesalahan: ${e.message}';
    }
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Gagal',
        message: errorMessage,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
