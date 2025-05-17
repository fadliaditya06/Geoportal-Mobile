import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoportal_mobile/widget/custom_snackbar.dart';

class UbahKataSandiController {
  final TextEditingController kataSandiLamaController = TextEditingController();
  final TextEditingController kataSandiBaruController = TextEditingController();
  final TextEditingController konfirmasiKataSandiController = TextEditingController();

  Future<void> changePassword(BuildContext context) async {
    final kataSandiLama = kataSandiLamaController.text.trim();
    final kataSandiBaru = kataSandiBaruController.text.trim();
    final konfirmasiKataSandi = konfirmasiKataSandiController.text.trim();

    // Validasi awal
    if (kataSandiBaru == kataSandiLama) {
      showCustomSnackbar(
        context: context,
        message: 'Kata sandi baru tidak boleh sama dengan kata sandi lama',
        isSuccess: false,
      );
      return;
    }

    if (kataSandiBaru != konfirmasiKataSandi) {
      showCustomSnackbar(
        context: context,
        message: 'Konfirmasi kata sandi tidak cocok dengan kata sandi baru',
        isSuccess: false,
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showCustomSnackbar(
        context: context,
        message: 'User tidak ditemukan',
        isSuccess: false,
      );
      return;
    }
    
    // Fungsi untuk mengupdate kata sandi di Firestore
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: kataSandiLama,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(kataSandiBaru);

      showCustomSnackbar(
        context: context,
        message: 'Ubah kata sandi berhasil',
        isSuccess: true,
      );
      Navigator.pop(context);
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'Kata sandi lama salah atau terjadi kesalahan lain',
        isSuccess: false,
      );
    }
  }

  void dispose() {
    kataSandiLamaController.dispose();
    kataSandiBaruController.dispose();
    konfirmasiKataSandiController.dispose();
  }
}
