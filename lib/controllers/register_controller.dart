import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';

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
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Pendaftaran akun berhasil',
        isSuccess: true,
      );
      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);

      // Navigasi ke halaman login setelah registrasi berhasil
      Navigator.of(context).pushNamed('/login');
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _handleAuthError(context, e);
      }
    } catch (e) {
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: 'Terjadi kesalahan: ${e.toString()}',
          isSuccess: false,
        );
      }
    }
  }

  // Fungsi untuk menyimpan data user ke Firestore
  Future<void> _storeUserData(User user) async {
    await _firestore.collection('user').doc(user.uid).set({
      'uid': user.uid,
      'email': emailController.text.trim(),
      'nama': namaController.text.trim(),
      'alamat': alamatController.text.trim(),
      'peran': selectedRole,
      'foto_profil': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Fungsi untuk menangani kesalahan autentikasi dan menampilkan snackbar
  void _handleAuthError(BuildContext context, FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'Email ini sudah terdaftar';
        break;
      default:
        errorMessage = 'Terjadi kesalahan: ${e.message}';
    }
    showCustomSnackbar(
      context: context,
      message: errorMessage,
      isSuccess: false,
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
