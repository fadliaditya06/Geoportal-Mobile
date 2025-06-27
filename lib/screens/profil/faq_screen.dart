import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB0E1C6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "FAQ",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kami siap bantu kamu\ndalam segala hal terkait Geoportal",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Butuh bantuan? Cek pertanyaan yang sering ditanyakan!",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Image.asset(
                    'assets/images/icon/faq.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),

                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: ' Pertanyaan ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: 'Umum'),
                    ],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF358666)),
                  ),
                ),
                const SizedBox(height: 12),

                // Daftar FAQ
                const ItemFAQ(
                  pertanyaan: "Apa itu Aplikasi Geoportal?",
                  jawaban:
                      "Aplikasi Geoportal adalah platform digital yang dirancang untuk menampilkan informasi serta mengelola data terkait perumahan dan permukiman.",
                ),
                const ItemFAQ(
                  pertanyaan:
                      "Bagaimana cara menambahkan data terkait perumahan dan permukiman?",
                  jawaban:
                      "Mengisi form pada halaman tambah data, seperti nama lokasi, mengunggah foto lokasi, dan menambahkan titik koordinat.",
                ),
                const ItemFAQ(
                  pertanyaan: "Siapa saja yang bisa mengakses aplikasi ini?",
                  jawaban:
                      "Semua masyarakat umum di Kota Batam bisa melihat data dan memberikan kontribusi secara langsung.",
                ),
                const ItemFAQ(
                  pertanyaan:
                      "Apakah pengguna harus login untuk mengakses seluruh fitur aplikasi?",
                  jawaban:
                      "Semua pengguna harus memiliki akun dan kemudian melakukan login untuk melihat atau menambah data.",
                ),
                const ItemFAQ(
                  pertanyaan:
                      "Apakah data yang telah saya kelola akan langsung ditampilkan pada peta?",
                  jawaban:
                      "Data akan ditinjau dan divalidasi terlebih dahulu oleh admin. Jika disetujui, maka data tersebut akan ditampilkan.",
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemFAQ extends StatefulWidget {
  final String pertanyaan;
  final String jawaban;

  const ItemFAQ({
    super.key,
    required this.pertanyaan,
    required this.jawaban,
  });

  @override
  State<ItemFAQ> createState() => _ItemFAQState();
}

class _ItemFAQState extends State<ItemFAQ> {
  bool _terbuka = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.8,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          widget.pertanyaan,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Icon(_terbuka ? Icons.expand_less : Icons.expand_more),
        onExpansionChanged: (value) => setState(() => _terbuka = value),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.jawaban,
              textAlign: TextAlign.left,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}
