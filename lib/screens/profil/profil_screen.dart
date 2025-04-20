import 'package:flutter/material.dart';
import 'package:geoportal_mobile/screens/auth/login_screen.dart';
import 'package:geoportal_mobile/screens/profil/lihat_profil_screen.dart';
import 'package:geoportal_mobile/screens/profil/syarat_dan_ketentuan_screen.dart';
import 'package:geoportal_mobile/screens/profil/ubah_kata_sandi_screen.dart';
import 'package:geoportal_mobile/screens/profil/ubah_profil_screen.dart';

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
      body: Container(
        decoration: BoxDecoration(
          // Gradien Background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.6, 1.0],
            colors: [
              const Color(0xFFFFFFFF),
              const Color(0xFF72B396).withOpacity(0.15),
              const Color(0xFF358666).withOpacity(0.60),
              const Color(0xFFFFFFFF).withOpacity(0.98),
            ],
          ),
        ),
        // Header Profil
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFB0E1C6),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(70)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Color(0xFF358666),
                      child: Icon(Icons.person, size: 100, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Fadli Aditya",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Box Container Profil
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      onTap: () =>
                          _navigateTo(context, const UbahProfilScreen()),
                    ),
                    _buildProfilMenu(
                      icon: Icons.lock_outline,
                      title: "Ubah Kata Sandi",
                      onTap: () =>
                          _navigateTo(context, const UbahKataSandiScreen()),
                    ),
                    _buildProfilMenu(
                      icon: Icons.info_outline,
                      title: "Syarat & Ketentuan",
                      onTap: () => _navigateTo(
                          context, const SyaratdanKetentuanScreen()),
                    ),
                    const SizedBox(height: 30),
                    // Tombol Logout
                    SizedBox(
                      width: 150,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF358666),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
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
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan menu profil
  static Widget _buildProfilMenu({
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

  // Method untuk navigasi ke halaman lain
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
