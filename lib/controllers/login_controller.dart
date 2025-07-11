import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'package:geoportal_mobile/utils/secure_storage.dart';
import 'package:geoportal_mobile/models/user_model.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController kataSandiController = TextEditingController();
  String? selectedRole;

  // Fungsi untuk menangani proses login
  Future<void> login(BuildContext context) async {
    try {
      final email = emailController.text.trim();
      final kataSandi = kataSandiController.text;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: kataSandi,
      );

      String uid = userCredential.user!.uid;
      // Ambil data pengguna dari Firestore
      DocumentSnapshot userDoc = await _firestore.collection('user').doc(uid).get();

      if (!userDoc.exists) {
        if (!context.mounted) return;
        showCustomSnackbar(
          context: context,
          message: 'Data pengguna tidak ditemukan',
          isSuccess: false,
        );
        return;
      }

      // Konversi ke model
      UserModel user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      // Validasi peran pengguna
      if (user.peran != selectedRole) {
        if (!context.mounted) return;
        showCustomSnackbar(
          context: context,
          message: 'Peran yang dipilih tidak sesuai',
          isSuccess: false,
        );
        return;
      }

      // Simpan token dan peran pengguna menggunakan SecureStorage
      await SecureStorage.simpanDataLogin(user.uid, user.peran);

      // Jika berhasil login, arahkan ke dashboard sesuai peran
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Login berhasil',
        isSuccess: true,
      );

      Navigator.of(context).pushReplacementNamed('/main');

      // Validasi jika email dan kata sandi tidak valid
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: 'Email atau kata sandi tidak valid',
          isSuccess: false,
        );
        // ignore: avoid_print
        print('FirebaseAuthException: ${e.code} - ${e.message}');
      }
    } catch (e) {
      // Validasi jika terjadi kesalahan
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: 'Terjadi kesalahan: ${e.toString()}',
          isSuccess: false,
        );
      }
    }
  }

  // Fungsi untuk menangani logout
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      await SecureStorage.clear();

      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Logout berhasil',
        isSuccess: true,
      );
    } catch (e) {
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: 'Terjadi kesalahan saat logout: $e',
          isSuccess: false,
        );
      }
    }
  }

  // Fungsi untuk mengambil role pengguna dari secure storage
  Future<String?> getRole() async {
    return await SecureStorage.getRole();
  }

  // Fungsi untuk memeriksa apakah pengguna sudah login
  Future<bool> isLoggedIn() async {
    final token = await SecureStorage.getToken();
    return token != null;
  }

  void dispose() {
    emailController.dispose();
    kataSandiController.dispose();
  }
}
