import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
        showAwesomeSnackbar(
          context: context,
          title: 'Gagal',
          message: 'Peran yang dipilih tidak sesuai',
          contentType: ContentType.failure,
        );
        return;
      }

      // Simpan token dan peran pengguna
      await _secureStorage.write(key: 'auth_token', value: uid);
      await _secureStorage.write(key: 'user_role', value: role);

      // Jika berhasil login, arahkan ke dashboard sesuai peran
      if (!context.mounted) return;
      showAwesomeSnackbar(
        context: context,
        title: 'Berhasil',
        message: 'Berhasil login sebagai $role',
        contentType: ContentType.success,
      );

      // Arahkan ke dashboard jika login berhasil
      Navigator.of(context).pushReplacementNamed('/main');

      // Validasi jika email dan kata sandi tidak valid
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showAwesomeSnackbar(
          context: context,
          title: 'Gagal',
          message: 'Email atau kata sandi tidak valid',
          contentType: ContentType.failure,
        );
        // ignore: avoid_print
        print('FirebaseAuthException: ${e.code} - ${e.message}');
      }
    } catch (e) {
      // Validasi jika terjadi kesalahan
      if (context.mounted) {
        showAwesomeSnackbar(
          context: context,
          title: 'Gagal',
          message: 'Terjadi kesalahan: ${e.toString()}',
          contentType: ContentType.failure,
        );
      }
    }
  }

  // Fungsi untuk menangani logout
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      await _secureStorage.deleteAll();

      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Berhasil',
          message: 'Berhasil logout dari akun',
          contentType: ContentType.success,
        ),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Gagal',
          message: 'Terjadi kesalahan saat logout: $e',
          contentType: ContentType.failure,
        ),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

// Fungsi untuk menampilkan semua snackbar
void showAwesomeSnackbar({
  required BuildContext context,
  required String title,
  required String message,
  required ContentType contentType,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );
  
  // Fungsi untuk menampilkan snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
