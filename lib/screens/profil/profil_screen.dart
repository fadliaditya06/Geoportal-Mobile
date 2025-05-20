import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoportal_mobile/screens/auth/login_screen.dart';
import 'package:geoportal_mobile/screens/profil/lihat_profil_screen.dart';
import 'package:geoportal_mobile/screens/profil/syarat_dan_ketentuan_screen.dart';
import 'package:geoportal_mobile/screens/profil/ubah_kata_sandi_screen.dart';
import 'package:geoportal_mobile/screens/profil/ubah_profil_screen.dart';
import 'package:geoportal_mobile/controllers/login_controller.dart';
import 'package:geoportal_mobile/screens/modal/logout_alert.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final LoginController controller = LoginController();

  late Future<Map<String, dynamic>?> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = getUserData();
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
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
              Colors.white.withOpacity(0.98),
            ],
          ),
        ),

        // Menggunakan FutureBuilder untuk mengambil data user dari Firestore
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'));
            }

            // Jika data kosong atau dokumen user tidak ditemukan
            final data = snapshot.data;
            if (data == null) {
              return const Center(child: Text('Data user tidak ditemukan'));
            }

            // Jika data tersedia, ambil nama user dan URL foto profil dari Firestore
            final String namaUser = data['nama'] ?? 'Tidak ada nama';
            final String? fotoProfil = data['foto_profil'];

            // Header Profil
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB0E1C6),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: const Color(0xFF358666),
                          backgroundImage:
                              (fotoProfil != null && fotoProfil.isNotEmpty)
                                  ? NetworkImage(fotoProfil)
                                  : null,
                          child: (fotoProfil == null || fotoProfil.isEmpty)
                              ? const Icon(Icons.person,
                                  size: 100, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          namaUser,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Card Pengaturan Akun dan Informasi Lainnya
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Pengaturan Akun",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 10),
                        const Divider(thickness: 1, color: Colors.black),
                        const SizedBox(height: 10),
                        const Text(
                          "Informasi Lainnya",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildProfilMenu(
                          icon: Icons.info_outline,
                          title: "Syarat & Ketentuan",
                          onTap: () => _navigateTo(
                              context, const SyaratdanKetentuanScreen()),
                        ),
                        const SizedBox(height: 30),
                        // Tombol Logout
                        Center(
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF358666),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onPressed: () {
                                showLogoutDialog(
                                  context: context,
                                  onConfirm: () async {
                                    await controller.logout(context);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (route) => false,
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.logout,
                                  color: Colors.white, size: 20),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
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
  void _navigateTo(BuildContext context, Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    // Refresh data setelah dari screen lain
    setState(() {
      userDataFuture = getUserData();
    });
  }
}
