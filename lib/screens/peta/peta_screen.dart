import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geoportal_mobile/screens/peta/detail_peta_screen.dart';
import 'package:geoportal_mobile/screens/peta/permintaan_konfirmasi_screen.dart';
import 'package:geoportal_mobile/screens/peta/permintaan_konfirmasi_admin_screen.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';

class PetaScreen extends StatefulWidget {
  const PetaScreen({super.key, this.role});

  // Menyimpan peran user
  final String? role;

  @override
  PetaScreenState createState() => PetaScreenState();
}

class PetaScreenState extends State<PetaScreen> {
  final MapController _mapController = MapController();

  // Fungsi untuk memilih koordinat yang dipilih
  LatLng? _pickedLocation;

  // Fungsi untuk menavigasi ke halaman peta fullscreen
  void _goToFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailPetaScreen(
            isKonfirmasiKoordinat: true, isTambahData: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Center(
          child: Image.asset(
            'assets/images/logo/logo-geoportal-2.png',
            width: 100,
          ),
        ),
        title: const Text(
          "Geoportal",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.assignment_turned_in_outlined,
                color: Color(0xFF358666),
                size: 30,
              ),
              // Navigasi ke halaman Permintaan Konfirmasi sesuai peran
              onPressed: () {
                final role = widget.role ?? '';
                if (role == 'Admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PermintaanKonfirmasiAdminScreen(),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          // Box Pencarian
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: 'Cari peta...',
              //     prefixIcon: const Icon(
              //       Icons.search,
              //       color: Color(0xFF52525C),
              //     ),
              //     contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.0),
              //       borderSide:
              //           const BorderSide(color: Color(0xFF358666), width: 1),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.0),
              //       borderSide:
              //           const BorderSide(color: Color(0xFF358666), width: 1),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.0),
              //       borderSide:
              //           const BorderSide(color: Color(0xFF358666), width: 1),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              // Carousel Peta
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
              const SizedBox(height: 40),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Info',
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                    TextSpan(
                      text: 'grafis',
                      style: TextStyle(
                          color: Color(0xFF358666), fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black, thickness: 1),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {},
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/infografis-perumahan-batam.jpg',
                      height: 520,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Judul Akses Peta Digital
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Akses ',
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                    TextSpan(
                      text: 'Peta',
                      style: TextStyle(
                          color: Color(0xFF358666), fontFamily: 'Poppins'),
                    ),
                    TextSpan(
                      text: ' Digital',
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black, thickness: 1),
              const SizedBox(height: 20),
              // Daftar Peta
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFB0E1C6),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                // Fungsi untuk melihat peta
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                // Lokasi koordinat awal peta
                                initialCenter: const LatLng(1.13, 104.0531),
                                initialZoom: 12.0,
                                onTap: (tapPosition, point) {
                                  // Fungsi untuk menentukan koordinat saat peta di klik
                                  setState(() {
                                    _pickedLocation = point;
                                  });
                                  // // Salin koordinat yang dipilih
                                  // Clipboard.setData(
                                  //   ClipboardData(
                                  //       text:
                                  //           '${point.latitude}, ${point.longitude}'),
                                  // );
                                  // Snackbar untuk menampilkan data koordinat yang dipilih
                                  showCustomSnackbar(
                                    context: context,
                                    message:
                                        'Koordinat: ${point.latitude}, ${point.longitude}',
                                    isSuccess: true,
                                  );
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                ),
                                if (_pickedLocation != null)
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: _pickedLocation!,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            // Tombol untuk memperbesar peta
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: SizedBox(
                                width: 45,
                                height: 45,
                                child: FloatingActionButton(
                                  onPressed: _goToFullScreen,
                                  backgroundColor: const Color(0xFF92E3A9),
                                  child: const Icon(Icons.fullscreen,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Judul dan Deskripsi Peta
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Peta Batam',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Alokasi sebaran daerah Batam',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
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
                                Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF92E3A9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: 50,
                                    height: 35,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.download,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        //
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Tombol View
                                Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF92E3A9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: 70,
                                    height: 35,
                                    child: TextButton(
                                      onPressed: _goToFullScreen,
                                      child: const Text(
                                        'View',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
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
