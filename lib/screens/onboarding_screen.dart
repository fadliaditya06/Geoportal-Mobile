import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoportal_mobile/screens/auth/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

// Fungsi untuk pindah ke halaman selanjutnya
  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

// Fungsi untuk pindah ke halaman sebelumnya
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFBFFFC),
              Color(0xFFB0E1C6),
              Color(0xFF64C38F),
            ],
            stops: [0.0, 0.84, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),

              // Konten Onboarding
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  // Konten Onboarding Slide 1, 2, dan 3
                  children: [
                    _buildPage(
                      image: 'assets/images/onboarding/onboarding-1.png',
                      title: "Selamat Datang di Geoportal!",
                      description:
                          "\"Jelajahi, analisis, dan unduh data geospasial dengan mudah di Geoportal. Mari mulai perjalanan Anda!\"",
                    ),
                    _buildFeaturePage(
                      image: 'assets/images/onboarding/onboarding-2.png',
                      title: "Jelajahi dan Akses\nData Spasial!",
                    ),
                    _buildPage(
                      image: 'assets/images/onboarding/onboarding-3.png',
                      title: "Yuk Akses lebih\nMudah!",
                      description:
                          "\"Buat akun untuk menyimpan peta favorit dan mengunduh data dengan lebih fleksibel. Dapatkan pengalaman terbaik di Geoportal!\"",
                    ),
                  ],
                ),
              ),
              // Indikator Bar
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 9,
                    dotWidth: 9,
                    activeDotColor: const Color(0xFF358666),
                    dotColor: Colors.grey.shade400,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Tombol navigasi
              Row(
                mainAxisAlignment: _currentPage == 0
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    ElevatedButton(
                      onPressed: _previousPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF358666),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sebelumnya',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _currentPage == 2
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          }
                        : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPage == 2
                          ? const Color(0xFFB0E1C6)
                          : const Color(0xFF358666),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Mulai Sekarang' : 'Selanjutnya',
                      style: TextStyle(
                          color: _currentPage == 2 ? Colors.black : Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

// Widget untuk menampilkan konten pada setiap halaman
  Widget _buildPage(
      {required String image, required String title, String description = ""}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            image,
            height: 200,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(
          color: Colors.black,
          thickness: 1,
        ),
        const SizedBox(height: 10),
        if (description.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(left: 10, right: 20, top: 8),
            child: Text(
              description,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
      ],
    );
  }

// Widget untuk menampilkan fitur pada halaman kedua
  Widget _buildFeaturePage({required String image, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            image,
            height: 200,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(
          color: Colors.black,
          thickness: 1,
        ),
        const SizedBox(height: 10),
        _buildFeatureItem(CupertinoIcons.location_solid, "Lihat Peta",
            "Jelajahi peta interaktif dengan berbagai layer informasi."),
        _buildFeatureItem(Icons.edit_document, "Akses Data",
            "Temukan data geospasial yang akurat dan terpercaya."),
        _buildFeatureItem(CupertinoIcons.square_arrow_down_fill, "Unduh Data",
            "Simpan data sesuai kebutuhan Anda."),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.arrow_forward, size: 15, color: Colors.black),
          const SizedBox(width: 5),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: title == "Lihat Peta"
                    ? 15
                    : (title == "Akses Data" ? 5 : 0),
              ),
              child: Text(
                description,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
