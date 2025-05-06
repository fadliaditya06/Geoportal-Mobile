import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DetailKonfirmasiDataScreen extends StatefulWidget {
  const DetailKonfirmasiDataScreen({super.key});

  @override
  DetailKonfirmasiDataScreenState createState() =>
      DetailKonfirmasiDataScreenState();
}

class DetailKonfirmasiDataScreenState
    extends State<DetailKonfirmasiDataScreen> {
      // Menyimpan status visibilitas gambar (tampil atau tidak)
  final Map<String, bool> _imageVisibilityMap = {};

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
          "Detail Data",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
      ),
      // Gradien Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.36, 0.76, 0.93],
            colors: [
              Color(0xFFB0E1C6),
              Color(0xFFFFFFFF),
              Color(0xFF72B396),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Permintaan Konfirmasi Data
                Card(
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
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hana Annisa',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Permintaan Konfirmasi \nData',
                                  style: TextStyle(
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
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hana Annisa',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Permintaan Konfirmasi - One Batam Mall',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(CupertinoIcons.doc_fill,
                              size: 20, color: Color(0xFF358666)),
                          SizedBox(width: 8),
                          Text(
                            'Katalog Lokal',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.access_time_filled,
                              size: 20, color: Color(0xFF358666)),
                          SizedBox(width: 8),
                          Text(
                            '10 April 2024',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  color: const Color(0xFFB0E1C6),
                  elevation: 0,
                  child: SizedBox(
                    height: 500,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Card Identifikasi
                            Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                side: BorderSide(
                                    color: Color(0xFFD9D9D9), width: 2),
                              ),
                              color: const Color(0xFFD6F0E1),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Identifikasi',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const Divider(color: Colors.black),
                                    const SizedBox(height: 8),
                                    _buildInfoRow('Judul', 'One Batam Mall'),
                                    const Divider(color: Colors.black),
                                    _buildInfoRow('Pemilik', 'Fadli Aditya'),
                                    const Divider(color: Colors.black),
                                    _buildInfoRow('Publikasi', '10 April 2024'),
                                    const Divider(color: Colors.black),
                                    _buildInfoRow('Ditambahkan ke Katalog',
                                        '10 April 2024'),
                                    const Divider(color: Colors.black),
                                    _buildInfoRow(
                                        'Modifikasi Terakhir', '10 April 2024'),
                                    const Divider(color: Colors.black),
                                    _buildInfoRow('Jenis Sumber Daya', '-'),
                                    const Divider(color: Colors.black),
                                    _buildInfoRow('Sumber', 'Lokal'),
                                    const Divider(color: Colors.black),
                                    _buildInfoRow('Informasi Tambahan', '-'),
                                    const Divider(color: Colors.black),
                                    _buildInfoRow('Gambar',
                                        'assets/images/one-mall-batam.jpeg'),
                                    const Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Card Informasi Spasial
                            Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                side: BorderSide(
                                    color: Color(0xFFD9D9D9), width: 2),
                              ),
                              color: const Color(0xFFD6F0E1),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Informasi Spasial',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const Divider(color: Colors.black),
                                    const SizedBox(height: 8),
                                    _buildInfoRow('Sistem Proyeksi',
                                        'EPSG:4326 (WGS 84)'),
                                    const Divider(color: Colors.black),
                                    _buildInfoRow('Titik Koordinat',
                                        '1.123656080648241, \n104.04652457983983'),
                                    const Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionIcon(Icons.check),
                    const SizedBox(width: 12),
                    _buildActionIcon(Icons.close),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Fungsi untuk menampilkan informasi data
  Widget _buildInfoRow(String label, String value) {
    // Memeriksa apakah value memiliki ekstensi gambar (png, jpg, jpeg)
    bool isImage = value.endsWith('.png') ||
        value.endsWith('.jpg') ||
        value.endsWith('.jpeg');
    // Jika value adalah gambar, tampilkan gambar dengan toggle
    if (isImage) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageVisibilityMap[label] =
                          !_imageVisibilityMap.containsKey(label) ||
                              !_imageVisibilityMap[label]!;
                    });
                  },
                  child: Icon(
                    _imageVisibilityMap[label] == true
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            if (_imageVisibilityMap[label] == true)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.asset(
                  value,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      );
    } else {
      // Jika bukan value gambar, tampilkan teks biasa
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }
  // Fungsi untuk membuat icon disetujui dan ditolak
  Widget _buildActionIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF358666), width: 1),
      ),
      padding: const EdgeInsets.all(10),
      child: Icon(
        icon,
        color: Colors.black,
        size: 20,
      ),
    );
  }
}
