import 'package:flutter/material.dart';
import 'package:geoportal_mobile/screens/modal/galery_modal.dart';
import 'package:geoportal_mobile/screens/peta/permintaan_konfirmasi_admin_screen.dart';
import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geoportal_mobile/screens/peta/permintaan_konfirmasi_screen.dart';

class BerandaScreen extends StatefulWidget {
  final String uid;

  const BerandaScreen({super.key, required this.uid});

  @override
  BerandaScreenState createState() => BerandaScreenState();
}

class BerandaScreenState extends State<BerandaScreen> {
  String? userName;

  // Fungsi untuk mengambil nama depan
  String getFirstName(String fullName) {
    return fullName.split(' ').first;
  }

  bool isLoading = true;
  String? error;

  // Menyimpan peran user
  String? role;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // Fungsi untuk mengambil data user berdasarkan uid
  Future<void> _fetchUserName() async {
    try {
      final userData = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();

      if (mounted) {
        setState(() {
          userName = userData['nama'] ?? 'Pengguna';
          role = userData['peran'] ?? 'pengguna';
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Gagal mengambil data pengguna';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Geoportal",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: Center(
            child: Image.asset(
              'assets/images/logo/logo-geoportal-2.png',
              width: 100,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.assignment_turned_in_outlined,
                    color: Color(0xFF358666), size: 30),
                // Navigasi ke halaman Permintaan Konfirmasi sesuai peran
                onPressed: () {
                  if (role == 'Admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PermintaanKonfirmasiAdminScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PermintaanKonfirmasiScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
            child: isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      double width;
                      double height;
                      switch (index % 3) {
                        case 0:
                          width = 150;
                          height = 30;
                          break;
                        case 1:
                          width = 200;
                          height = 50;
                          break;
                        case 2:
                        default:
                          width = 350;
                          height = 120;
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            CardLoading(
                              height: height,
                              width: width,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : error != null
                    ? Center(child: Text(error!))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: 'Hi'),
                                  TextSpan(
                                    text:
                                        ' ${getFirstName(userName ?? 'Pengguna')}',
                                    style: const TextStyle(
                                      color: Color(0xFF358666),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: '!'),
                                ],
                              ),
                              style: const TextStyle(fontSize: 26),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Selamat datang ${getFirstName(userName ?? 'Pengguna')}!',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 8),
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: 'Ayo temukan'),
                                  TextSpan(
                                    text: ' Peta ',
                                    style: TextStyle(
                                        color: Color(0xFF358666),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: '\nkamu!'),
                                ],
                              ),
                              style: TextStyle(fontSize: 26),
                            ),
                            const SizedBox(height: 16),
                            // Carousel Beranda
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 225,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                                aspectRatio: 16 / 9,
                                autoPlayInterval: const Duration(seconds: 3),
                              ),
                              items: [
                                'assets/carousel/carousel-perumahan.png',
                                'assets/carousel/carousel-permukiman.png',
                                'assets/carousel/carousel-pertamanan.png',
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
                            const SizedBox(height: 24),
                            // Konten Eksplor Fitur Kami
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: 'Yuk Eksplor'),
                                  TextSpan(
                                    text: ' Fitur ',
                                    style: TextStyle(
                                      color: Color(0xFF358666),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: 'Kami'),
                                ],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Card Eksplor Fitur Kami
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF64C38F),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SizedBox(
                                height: 340,
                                child: ListView.builder(
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        _eksplorItem(
                                          image:
                                              'assets/images/eksplor-fitur/eksplor-fitur-${index + 1}.png',
                                          title: index == 0
                                              ? 'Pencarian & Visualisasi Data'
                                              : index == 1
                                                  ? 'Manajemen Data & Kolaborasi'
                                                  : 'Profil Pengguna',
                                          description: index == 0
                                              ? 'Menampilkan berbagai data geospasial dalam bentuk peta digital, memungkinkan pengguna untuk mencari dan memahami informasi dengan lebih mudah.'
                                              : index == 1
                                                  ? 'Memungkinkan pengguna untuk mengunggah, berbagi, dan mengelola data geospasial secara terpusat untuk mendukung kerja sama dalam pengambilan keputusan.'
                                                  : 'Memungkinkan setiap pengguna untuk memiliki akun pribadi, dan dapat mengedit informasi profil.',
                                        ),
                                        if (index != 2)
                                          const SizedBox(height: 16),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Konten Berita Terbaru
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Berita',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF358666),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Terbaru',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            _beritaCard(),
                            const SizedBox(height: 24),
                            // Bagian Galery Kami
                            _sectionTitle(
                              'Galery',
                              'Kami',
                              onTap: () {},
                              titleColor: const Color(0xFF358666),
                              subTitleColor: Colors.black,
                            ),
                            const SizedBox(height: 12),
                            // Daftar Galeri
                            _galeriList(),
                            const SizedBox(height: 50),
                            // Galeri List Tambahan
                            _galeriListTambahan(),
                            const SizedBox(height: 12),
                          ],
                        ))));
  }

  // Fungsi untuk menampilkan konten eksplor fitur
  static Widget _eksplorItem({
    required String image,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Konten Card
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF64C38F),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  width: 108,
                  height: 108,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    const SizedBox(height: 8),
                    Text(description,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Fungsi untuk menampilkan title
  static Widget _sectionTitle(String title1, String title2,
      {required VoidCallback onTap, Color? titleColor, Color? subTitleColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title1,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    fontFamily: 'Poppins'),
              ),
              TextSpan(
                text: ' $title2',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: subTitleColor ?? Colors.black,
                    fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
        // Panggil modal galery
        Builder(
          builder: (BuildContext context) {
            return TextButton(
              onPressed: () {
                GaleriModal.showGaleriModal(context);
              },
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: Color(0xFF358666),
                  decoration: TextDecoration.underline,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Fungsi untuk menampilkan berita
  static Widget _beritaCard() {
    return SizedBox(
      height: 420,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(blurRadius: 4, color: Colors.black12)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/berita/berita-${index + 1}.png',
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rapat Koordinasi Kelompok Kerja Pengembangan Infrastruktur Data Geospasial',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0XFF358666)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '“Selaku Ketua Pokja PKP, Saya menyambut baik dilaksanakannya Koordinasi ini. Bersama stake holder Kita sinkronkan kegiatan untuk mendukung sasaran dan tujuan pembangunan perumahan dan kawasan permukiman termasuk pencegahan dan penanganan permukiman kumuh dan penanggulangan kemiskinan,”',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 7,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Fungsi untuk menampilkan daftar galeri
  static Widget _galeriList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF358666)),
      ),
      child: SizedBox(
        height: 400,
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return Column(
              children: [
                _galeriItem(
                  image: 'assets/images/galeri/galeri-${index + 1}.png',
                  title: index == 0
                      ? 'Sekupang'
                      : index == 1
                          ? 'Sei Beduk'
                          : index == 2
                              ? 'Nongsa'
                              : 'Batu Aji',
                  description: index == 0
                      ? 'Luas Kecamatan Sekupang, Kota Batam adalah 106,78 kilometer persegi (km2).'
                      : index == 1
                          ? 'Luas Kecamatan Sei Beduk, Kota Batam adalah 101,63 kilometer persegi (km2).'
                          : index == 2
                              ? 'Luas Kecamatan Nongsa, Kota Batam adalah 145,32  kilometer persegi (km2).'
                              : 'Luas Kecamatan Batu Aji, Kota Batam adalah 20,13  kilometer persegi (km2).',
                ),
                if (index != 3) const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan galeri item dengan gambar, judul, dan deskripsi
  static Widget _galeriItem({
    required String image,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8D8D8), width: 3),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 120,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF358666),
                  ),
                ),
                const Divider(
                  color: Color(0xFF358666),
                  thickness: 1,
                  height: 8,
                ),
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
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan galeri list tambahan
  static Widget _galeriListTambahan() {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.asset(
                'assets/images/galeri/galeri-${index + 1}.png',
                width: 220,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
