import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geoportal_mobile/widget/custom_snackbar.dart';

class DetailPetaScreen extends StatefulWidget {
  const DetailPetaScreen({super.key});

  @override
  State<DetailPetaScreen> createState() => _DetailPetaScreenState();
}

class _DetailPetaScreenState extends State<DetailPetaScreen> {
  // Variabel untuk menyimpan koordinat lokasi yang dipilih
  LatLng? _pickedLocation;

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

    // Snackbar untuk menampilkan data koordinat yang dipilih
    showCustomSnackbar(
      context: context,
      message: 'Koordinat disalin: ${point.latitude}, ${point.longitude}',
      isSuccess: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            // Lokasi koordinat awal peta
            options: MapOptions(
              initialCenter: const LatLng(1.13, 104.0531),
              initialZoom: 12.0,
              onTap: (tapPosition, point) {
                _selectLocation(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              // Menampilkan marker jika lokasi telah dipilih
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

          // Tombol Search dan Tambah Koordinat
          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isSearching
                    ? Container(
                        width: 330,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
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

                            // Tombol Search Bar
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
                              icon:
                                  const Icon(Icons.close, color: Colors.black),
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
                    // Tombol Mini Search Bar
                    : SizedBox(
                        height: 55,
                        width: 55,
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                          shape: const CircleBorder(),
                          fillColor: Colors.white,
                          elevation: 2,
                          child: const Icon(Icons.search,
                              size: 20, color: Colors.black),
                        ),
                      ),
                const SizedBox(height: 10),

                // Tombol Tambah Koordinat
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xFF358666),
                    size: 20,
                  ),
                  label: const Text(
                    'Tambah Koordinat',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF92E3A9),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                            color: Color(0xFF358666), width: 1)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
