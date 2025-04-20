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
        ),
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          // Gradien Background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.6, 1.0],
            colors: [
              const Color(0xFFB0E1C6),
              const Color(0xFF72B396).withOpacity(0.31),
              const Color(0xFF358666).withOpacity(0.60),
              const Color(0xFFFFFFFF).withOpacity(0.98),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Ikon Profil
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                child: const CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xFF358666),
                  child: Icon(Icons.person, size: 100, color: Colors.white),
                ),
              ),
              // Box Container Profil
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfilItem(
                          label: "Email",
                          value: "fadli@gmail.com",
                          icon: Icons.email_outlined,
                        ),
                        _ProfilItem(
                          label: "Nama Lengkap",
                          value: "Fadli Aditya",
                          icon: Icons.person_outlined,
                        ),
                        _ProfilItem(
                          label: "Alamat",
                          value: "Perumahan Sukajadi",
                          icon: Icons.home_outlined,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fungsi untuk menampilkan konten profil
class _ProfilItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfilItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFB0E1C6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
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
