import 'package:flutter/material.dart';

class SyaratdanKetentuanScreen extends StatelessWidget {
  const SyaratdanKetentuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left,
                          size: 30, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Syarat & Ketentuan",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Box Container
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: const SingleChildScrollView(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Syarat & Ketentuan',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF358666)),
                          textAlign: TextAlign.left,
                        ),
                        Divider(thickness: 1),
                        Text(
                          'Geoportal adalah platform informasi geospasial untuk analisis dan perencanaan. Dengan menggunakan layanan ini, pengguna menyetujui syarat dan ketentuan yang berlaku.\n\n',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Syarat Penggunaan\n',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF358666)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Hak dan Kewajiban Pengguna',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF358666)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '\u2022 Dapat: Mengakses, menggunakan, dan membagikan data jika diizinkan.\n'
                          '\u2022 Dilarang: Menggunakan data secara ilegal, mengubah tanpa izin, atau merusak sistem.\n',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Hak dan Kewajiban Pengelola',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF358666)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '\u2022 Berhak memperbarui atau menghapus data tanpa pemberitahuan.\n'
                          '\u2022 Tidak bertanggung jawab atas kesalahan data atau dampaknya.\n'
                          '\u2022 Dapat membatasi akses pengguna yang melanggar ketentuan.\n\n',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Ketentuan Penggunaan\n',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF358666)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Hak Kekayaan Intelektual',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF358666)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '\u2022 Data memiliki hak cipta, pengguna wajib mematuhi lisensi yang berlaku.\n'
                          '\u2022 Data pihak ketiga harus digunakan sesuai ketentuannya.\n',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Batasan Tanggung Jawab',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF358666)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '\u2022 Geoportal disediakan apa adanya tanpa jaminan keakuratan.\n'
                          '\u2022 Pengguna bertanggung jawab atas penggunaan data.\n'
                          '\u2022 Pengelola tidak bertanggung jawab atas dampak penggunaan data.\n',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Kebijakan Privasi',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF358666)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '\u2022 Jika data pengguna dikumpulkan, digunakan sesuai kebijakan privasi.\n'
                          '\u2022 Data pribadi tidak disebarluaskan tanpa izin kecuali diwajibkan hukum.\n',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Hak Kekayaan Intelektual',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF358666)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '\u2022 Ketentuan dapat berubah sewaktu-waktu.\n'
                          '\u2022 Pembaruan penting akan diinformasikan melalui kanal resmi.\n',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Dengan menggunakan Geoportal, pengguna dianggap telah menyetujui semua syarat dan ketentuan di atas.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
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
