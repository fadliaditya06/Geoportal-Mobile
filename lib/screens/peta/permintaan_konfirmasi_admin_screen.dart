import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PermintaanKonfirmasiAdminScreen extends StatefulWidget {
  const PermintaanKonfirmasiAdminScreen({super.key});

  @override
  PermintaanKonfirmasiAdminScreenState createState() =>
      PermintaanKonfirmasiAdminScreenState();
}

class PermintaanKonfirmasiAdminScreenState
    extends State<PermintaanKonfirmasiAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Permintaan Konfirmasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      // Gradien Background
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.36, 0.76, 1.0],
            colors: [
              Color(0xFFB0E1C6),
              Color(0xFFFFFFFF),
              Color(0xFF72B396),
              Color(0xFF358666),
            ],
          ),
        ),
        // Isi Konten
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Data Dummy untuk Card Permintaan Konfirmasi
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/detail-konfirmasi');
                        },
                        child: _permintaanKonfirmasiCard(
                          title: 'Hana Annisa',
                          description: 'Permintaan Konfirmasi Data',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tombol Disetujui dan Ditolak
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: _permintaanKonfirmasiIcon(
                              icon: CupertinoIcons.checkmark_alt),
                        ),
                        const SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: _permintaanKonfirmasiIcon(icon: Icons.close),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  // Fungsi untuk membuat card permintaan konfirmasi
  Widget _permintaanKonfirmasiCard({
    required String title,
    required String description,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF358666)),
      ),
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Profil
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF358666),
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Fungsi untuk menampilkan nama dan deskripsi
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Fungsi untuk membuat icon disetujui dan ditolak
  Widget _permintaanKonfirmasiIcon({required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFB0E1C6),
        border: Border.all(
          color: const Color(0xFF358666),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(icon, size: 22, color: Colors.black),
    );
  }
}
