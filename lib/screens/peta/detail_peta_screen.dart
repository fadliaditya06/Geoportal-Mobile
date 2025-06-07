import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geoportal_mobile/controllers/detail_peta_controller.dart';
import 'package:geoportal_mobile/widgets/detail_data_bottom_sheet.dart';

class DetailPetaScreen extends StatefulWidget {
  final bool isKonfirmasiKoordinat;
  final bool isTambahData;

  const DetailPetaScreen({
    super.key,
    this.isKonfirmasiKoordinat = false,
    this.isTambahData = true,
  });

  @override
  State<DetailPetaScreen> createState() => _DetailPetaScreenState();
}

class _DetailPetaScreenState extends State<DetailPetaScreen> {
  late DetailPetaController _controller;
  List<String> _suggestions = [];
  final MapController mapController = MapController();
  List<Marker> propertyMarkers = [];
  List<Polygon> geoJsonPolygons = [];

  @override
  void initState() {
    super.initState();
    _controller = DetailPetaController();
    _loadGeoJson();
  }

  Future<void> _loadGeoJson() async {
    await _controller.loadGeoJsonMultiple(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _controller.mapController,
            options: MapOptions(
              initialCenter:
                  const LatLng(-0.17325329329556474, 127.88725441653283),
              initialZoom: 8.0,
              onMapReady: () {
                _controller.mapController.move(
                    const LatLng(-0.17325329329556474, 127.88725441653283),
                    8.0);
              },
              onTap: (tapPosition, latLng) async {
                final nearbyData =
                    await _controller.selectLocation(latLng, context);
                if (nearbyData != null && context.mounted) {
                  _tampilkanBottomSheet(context, nearbyData);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              PolygonLayer(polygons: geoJsonPolygons),
              MarkerLayer(markers: _controller.markers),
              MarkerLayer(markers: propertyMarkers),
            ],
          ),

          // Tombol Search
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.black),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller.searchController,
                            decoration: const InputDecoration(
                              hintText: 'Cari peta...',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onChanged: (value) async {
                              if (value.isNotEmpty) {
                                final results =
                                    await _controller.getSuggestions(value);
                                setState(() {
                                  _suggestions = results;
                                });
                              } else {
                                setState(() {
                                  _suggestions = [];
                                });
                              }
                            },
                            onSubmitted: (value) async {
                              if (value.isNotEmpty) {
                                final data = await _controller
                                    .cariDanTampilkanLokasi(context, value);
                                if (data != null) {
                                  _tampilkanBottomSheet(context, data);
                                }
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            _controller.searchController.clear();
                            setState(() {
                              _suggestions = [];
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // Rekomendasi Search
                  if (_suggestions.isNotEmpty)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: _suggestions.map((s) {
                          return ListTile(
                            title: Text(s),
                            leading: const Icon(Icons.location_on,
                                color: Colors.black),
                            onTap: () async {
                              _controller.searchController.text = s;
                              setState(() {
                                _suggestions = [];
                              });
                              final data = await _controller
                                  .cariDanTampilkanLokasi(context, s);
                              if (data != null) {
                                _tampilkanBottomSheet(context, data);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    )

                  // Fungsi untuk menampilkan pesan jika tidak ada data
                  else if (_controller.searchController.text.isNotEmpty)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 60,
                      ),
                      child: const Center(
                        child: Text(
                          'Tidak ada data',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Tombol Tambah Data
          Positioned(
            left: 10,
            bottom: 110,
            child: ElevatedButton.icon(
              onPressed: widget.isTambahData
                  ? null
                  : () {
                      Navigator.pushNamed(context, '/tambah-data');
                    },
              icon: const Icon(Icons.add_location_alt,
                  color: Color(0xFF358666), size: 18),
              label: const Text(
                'Tambah Data',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.isTambahData ? Colors.grey : const Color(0xFF92E3A9),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // Copyright
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
                        _controller.showCopyrightOSM =
                            !_controller.showCopyrightOSM;
                      });
                    },
                    shape: const CircleBorder(),
                    fillColor: Colors.white,
                    elevation: 2,
                    child: const Icon(Icons.copyright,
                        size: 20, color: Colors.black),
                  ),
                ),
                if (_controller.showCopyrightOSM) const SizedBox(width: 5),
                if (_controller.showCopyrightOSM)
                  GestureDetector(
                    onTap: () => _controller.openOSMCopyrightLink(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
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

          // Zoom Button
          Positioned(
            bottom: 90,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      final currentZoom = _controller.mapController.camera.zoom;
                      _controller.mapController.move(
                        _controller.mapController.camera.center,
                        currentZoom + 1,
                      );
                    },
                  ),
                  Container(
                    height: 1,
                    width: 35,
                    color: Colors.grey,
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.black),
                    onPressed: () {
                      final currentZoom = _controller.mapController.camera.zoom;
                      _controller.mapController.move(
                        _controller.mapController.camera.center,
                        currentZoom - 1,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Tombol Konfirmasi
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: widget.isKonfirmasiKoordinat
                      ? null
                      : () {
                          final result = _controller.saveLocation();
                          if (result != null) {
                            Navigator.pop(context, result);
                          } else {
                            showCustomSnackbar(
                              context: context,
                              message: 'Pilih lokasi terlebih dahulu',
                              isSuccess: false,
                            );
                          }
                        },
                  icon: const Icon(Icons.check, color: Color(0xFF358666)),
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
                      borderRadius: BorderRadius.circular(30),
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

  void _tampilkanBottomSheet(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DetailDataBottomSheet(data: data);
      },
    );
  }
}
