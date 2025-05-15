import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoportal_mobile/widget/custom_snackbar.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController kataSandiController = TextEditingController();
  String? selectedRole;

  // Fungsi untuk menangani proses login
  Future<void> login(BuildContext context) async {
    try {
      final email = emailController.text.trim();
      final password = kataSandiController.text;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      DocumentSnapshot userData = await _firestore.collection('user').doc(uid).get();

      // Validasi peran pengguna
      String role = userData['peran'];
      if (role != selectedRole) {
        if (!context.mounted) return;
        showCustomSnackbar(
          context: context,
          message: 'Peran yang dipilih tidak sesuai',
          isSuccess: false,
        );
        return;
      }

      // Simpan token dan peran pengguna
      await _secureStorage.write(key: 'auth_token', value: uid);
      await _secureStorage.write(key: 'user_role', value: role);

      // Jika berhasil login, arahkan ke dashboard sesuai peran
      if (!context.mounted) return;
      showCustomSnackbar(
        context: context,
        message: 'Login berhasil',
        isSuccess: true,
      );

      // Arahkan ke dashboard jika login berhasil
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
      await _secureStorage.deleteAll();

      showCustomSnackbar(
        context: context,
        message: 'Logout berhasil',
        isSuccess: true,
      );
      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(Snackbar);
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'Terjadi kesalahan saat logout: $e',
        isSuccess: false,
      );
      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Fungsi untuk mengambil peran pennguna yang tersimpan
  Future<String?> getRole() async {
    return await _secureStorage.read(key: 'user_role');
  }

  // Fungsi untuk memeriksa apakah pengguna sudah login
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return token != null;
  }

  void dispose() {
    emailController.dispose();
    kataSandiController.dispose();
  }
}
