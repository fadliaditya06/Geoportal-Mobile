import 'package:flutter/material.dart';
import 'package:geoportal_mobile/screens/auth/login_screen.dart';
import 'package:geoportal_mobile/screens/profil/lihat_profil_screen.dart';
import 'package:geoportal_mobile/screens/profil/ubah_kata_sandi_screen.dart';
import 'package:geoportal_mobile/screens/profil/ubah_profil_screen.dart';
// import 'package:geoportal_mobile/screens/profil/ubah_profil_screen.dart';
// import 'package:geoportal_mobile/screens/profil/ubah_password_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profil
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFB0E1C6),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(50)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Color(0xFF358666),
                    child: Icon(Icons.person, size: 100, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Informasi Profil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfilMenu(
                    icon: Icons.person_outlined,
                    title: "Lihat Profil",
                    onTap: () =>
                        _navigateTo(context, const LihatProfilScreen()),
                  ),
                  _buildProfilMenu(
                    icon: Icons.edit_outlined,
                    title: "Ubah Profil",
                    onTap: () => _navigateTo(context, const UbahProfilScreen()),
                  ),
                  _buildProfilMenu(
                    icon: Icons.lock_outline,
                    title: "Ubah Kata Sandi",
                    onTap: () =>
                        _navigateTo(context, const UbahKataSandiScreen()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Tombol Logout
            SizedBox(
              width: 250,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF358666),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  // Navigator ke halaman login
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout,
                      color: Colors.white), 
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  // Widget untuk menampilkan menu profil dengan navigasi
  Widget _buildProfilMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFB0E1C6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
  // Fungsi untuk navigasi ke layar lain
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
