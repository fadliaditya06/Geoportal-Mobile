import 'package:flutter/material.dart';

class LihatProfilScreen extends StatelessWidget {
  const LihatProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Lihat Profil",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          textAlign: TextAlign.left,
        ),
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header Profil
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              width: double.infinity,
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
            const SizedBox(height: 10),
            // Bagian Informasi Profil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfilSection("Nama Depan", "Fadlitz", Icons.person_outlined),
                  _buildProfilSection("Nama Belakang", "Jago", Icons.person_outlined),
                  _buildProfilSection("Email", "fadlitzjago@gmail.com", Icons.email_outlined),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan informasi profil dengan judul di atas
  Widget _buildProfilSection(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFB0E1C6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: Icon(icon, color: Colors.black),
              title: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
