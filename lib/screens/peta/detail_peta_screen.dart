import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geoportal_mobile/widget/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPetaScreen extends StatefulWidget {
  final bool isKonfirmasiKoordinat;

  const DetailPetaScreen({super.key, this.isKonfirmasiKoordinat = false});

  @override
  State<DetailPetaScreen> createState() => _DetailPetaScreenState();
}

class _DetailPetaScreenState extends State<DetailPetaScreen> {
  // Variabel untuk menyimpan koordinat lokasi yang dipilih
  LatLng? _pickedLocation;

  bool _showCopyrightOSM = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Fungsi untuk memilih lokasi
  void _selectLocation(LatLng point) {
    setState(() {
      _pickedLocation = point;
    });

    // Salin koordinat ke clipboard
    Clipboard.setData(
      ClipboardData(
        text: '${point.latitude}, ${point.longitude}',
      ),
    );

    // // Snackbar untuk menampilkan data koordinat yang dipilih
    // showCustomSnackbar(
    //   context: context,
    //   message: 'Koordinat disalin: ${point.latitude}, ${point.longitude}',
    //   isSuccess: true,
    // );
  }

  // Fungsi untuk menyimpan lokasi dan kembali ke layar sebelumnya
  void _saveLocation() {
    if (_pickedLocation != null) {
      Navigator.pop(
        context,
        '${_pickedLocation!.latitude},${_pickedLocation!.longitude}',
      );
    } else {
      showCustomSnackbar(
        context: context,
        message: 'Pilih lokasi terlebih dahulu',
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Peta
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(1.13, 104.0531),
              initialZoom: 12.0,
              onTap: (tapPosition, point) => _selectLocation(point),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              // Menampilkan marker jika lokasi telah dipilih
              if (_pickedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _pickedLocation!,
                      rotate: false,
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

          // Tombol Search dan Tambah Koordinat
          Positioned(
            left: 10,
            bottom: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isSearching
                    ? Container(
                        width: 330,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.black),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Cari peta...',
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                setState(() {
                                  _isSearching = false;
                                  _searchController.clear();
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 45,
                        width: 45,
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                          shape: const CircleBorder(),
                          fillColor: Colors.white,
                          elevation: 2,
                          child: const Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                const SizedBox(height: 8),

                // Tombol Tambah Koordinat
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/tambah-data');
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xFF358666),
                    size: 18,
                  ),
                  label: const Text(
                    'Tambah Koordinat',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF92E3A9),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Link Copyright OSM
          Positioned(
            bottom: 55,
            left: 12,
            child: Row(
              children: [
                SizedBox(
                  height: 45,
                  width: 45,
                  child: RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        _showCopyrightOSM = !_showCopyrightOSM;
                      });
                    },
                    shape: const CircleBorder(),
                    fillColor: Colors.white,
                    elevation: 2,
                    child: const Icon(
                      Icons.copyright,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (_showCopyrightOSM) const SizedBox(width: 5),
                if (_showCopyrightOSM)
                  GestureDetector(
                    onTap: () async {
                      final uri =
                          Uri.parse('https://openstreetmap.org/copyright');
                      try {
                        final launched = await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                        if (!launched) {
                          showCustomSnackbar(
                            context: context,
                            message: 'Tidak dapat membuka tautan',
                            isSuccess: false,
                          );
                        }
                      } catch (_) {
                        showCustomSnackbar(
                          context: context,
                          message: 'Terjadi kesalahan saat membuka tautan',
                          isSuccess: false,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      color: Colors.white,
                      child: const Text(
                        'OpenStreetMap Contributors',
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Tombol Konfirmasi Koordinat
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: widget.isKonfirmasiKoordinat ? null : _saveLocation,
                  icon: const Icon(
                    Icons.check,
                    color: Color(0xFF358666),
                  ),
                  label: Text(
                    'Konfirmasi Koordinat',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isKonfirmasiKoordinat
                        ? Colors.grey
                        : const Color(0xFF92E3A9),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
