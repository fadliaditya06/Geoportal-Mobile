import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geoportal_mobile/screens/peta/permintaan_konfirmasi_screen.dart';

class PetaScreen extends StatelessWidget {
  const PetaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Image.asset(
            'assets/images/logo-geoportal-2.png',
            width: 100,
          ),
        ),
        title: const Text(
          "Geoportal",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.assignment_turned_in_outlined, color: Color(0xFF358666), size: 30),
              onPressed: () {
                // Navigasi ke halaman Permintaan Konfirmasi
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PermintaanKonfirmasiScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Box Pencarian
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari peta...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF52525C),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color(0xFF358666), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color(0xFF358666), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color(0xFF358666), width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Carousel Peta
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: [
                  'assets/carousel/peta-carousel-1.png',
                  'assets/carousel/peta-carousel-2.png',
                  'assets/carousel/peta-carousel-3.png',
                ].map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // Judul
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Akses ',
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                    TextSpan(
                      text: 'Peta',
                      style: TextStyle(color: Color(0xFF358666), fontFamily: 'Poppins'),
                    ),
                    TextSpan(
                      text: ' Digital',
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),

              // Garis Horizontal
              const Divider(color: Colors.black, thickness: 1),
              const SizedBox(height: 20),

              // Daftar Peta 
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFB0E1C6),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/images/peta-1.png',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul dan Deskripsi
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sebaran Mall',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Alokasi sebaran mall daerah Batam',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tombol Download dan View
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Row(
                              children: [
                                // Tombol Download
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF92E3A9),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  width: 50,
                                  height: 35,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.download,
                                          size: 18,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          // 
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Tombol View
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF92E3A9),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  width: 70,
                                  height: 35,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          // 
                                        },
                                        child: const Text(
                                          'View',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
}
