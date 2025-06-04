import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:geoportal_mobile/widgets/dummy_bottom_sheet.dart';

class DetailPetaController with ChangeNotifier {
  final MapController mapController = MapController();
  LatLng? pickedLocation;
  final List<Marker> _markers = [];
  final List<Polygon> _polygons = [];
  bool showCopyrightOSM = false;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  List<Marker> get markers => _markers;
  List<Polygon> get polygons => _polygons;

  Future<void> loadGeoJsonMultiple(BuildContext context) async {
    try {
      final String indexData = await rootBundle
          .loadString('assets/geojson/dummy-geojson/index.json');
      final List<dynamic> fileList = jsonDecode(indexData);

      _markers.clear();
      _polygons.clear();

      for (final filename in fileList) {
        final String data = await rootBundle
            .loadString('assets/geojson/dummy-geojson/$filename');
        final geoJson = jsonDecode(data);

        for (var feature in geoJson['features']) {
          final geometry = feature['geometry'];
          // final properties = feature['properties'];

          if (geometry == null || geometry['coordinates'] == null) continue;

          if (geometry['type'] == 'Polygon') {
            final coordinates = geometry['coordinates'][0];
            if (coordinates.isEmpty) continue;

            List<LatLng> points = coordinates
                .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
                .toList();

            _polygons.add(
              Polygon(
                points: points,
                color: Colors.yellow.withOpacity(0.3),
                borderColor: Colors.yellow,
                borderStrokeWidth: 2,
              ),
            );

            LatLng center = _getPolygonCenter(points);
            _markers.add(_buildMarker(center, feature, context));
          } else if (geometry['type'] == 'MultiPolygon') {
            for (final polygon in geometry['coordinates']) {
              final coordinates = polygon[0];
              if (coordinates.isEmpty) continue;

              List<LatLng> points = coordinates
                  .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
                  .toList();

              _polygons.add(
                Polygon(
                  points: points,
                  color: Colors.yellow.withOpacity(0.3),
                  borderColor: Colors.yellow,
                  borderStrokeWidth: 2,
                ),
              );

              LatLng center = _getPolygonCenter(points);
              _markers.add(_buildMarker(center, feature, context));
            }
          } else if (geometry['type'] == 'Point') {
            final coordinates = geometry['coordinates'];
            if (coordinates.length < 2) continue;

            LatLng point =
                LatLng(coordinates[1].toDouble(), coordinates[0].toDouble());

            _markers.add(_buildMarker(point, feature, context));
          }
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading GeoJSON: $e');
    }
  }

  LatLng _getPolygonCenter(List<LatLng> points) {
    double lat = 0;
    double lng = 0;
    for (var point in points) {
      lat += point.latitude;
      lng += point.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }

  Marker _buildMarker(
    LatLng position,
    Map<String, dynamic> feature,
    BuildContext context,
  ) {
    return Marker(
      point: position,
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () {
          _showDynamicBottomSheet(context, feature);
        },
        child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
      ),
    );
  }

  void _showDynamicBottomSheet(
      BuildContext context, Map<String, dynamic> feature) {
    final properties = feature['properties'] as Map<String, dynamic>? ?? {};
    final geometry = feature['geometry'] as Map<String, dynamic>? ?? {};

    // Ambil koordinat, format ke string lat,lng
    String coordinatesText = '-';
    final rawCoordinates = geometry['coordinates'];
    if (rawCoordinates != null && rawCoordinates is List) {
      var polygonPoints = rawCoordinates[0]; // ambil polygon pertama
      if (polygonPoints is List && polygonPoints.isNotEmpty) {
        final point = polygonPoints[0];
        coordinatesText = 'Lat: ${point[1]}, Lng: ${point[0]}';
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DummyBottomSheet(
        fclass: (properties['fclass'] ?? 'unknown').toString(),
        name: (properties['name'] ?? 'Tidak diketahui').toString(),
        code: _parseInt(properties['code']),
        population: _parseInt(properties['population']),
        osmId: (properties['osm_id'] ?? '-').toString(),
        coordinates: coordinatesText,
      ),
    );
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Future<Map<String, dynamic>?> findNearbyData(LatLng point) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('data_spasial').get();
      const toleranceMeters = 50;

      for (var doc in snapshot.docs) {
        final koordinatString = doc['titik_koordinat'] ?? '';
        final coords = koordinatString.split(',');

        if (coords.length == 2) {
          final lat = double.tryParse(coords[0].trim());
          final lng = double.tryParse(coords[1].trim());

          if (lat != null && lng != null) {
            final firestorePoint = LatLng(lat, lng);
            final distance = const Distance().as(
              LengthUnit.Meter,
              point,
              firestorePoint,
            );

            if (distance <= toleranceMeters) {
              final idDataSpasial = doc.id;

              final querySnapshot = await FirebaseFirestore.instance
                  .collection('data_umum')
                  .where('id_data_spasial', isEqualTo: idDataSpasial)
                  .get();

              if (querySnapshot.docs.isNotEmpty) {
                final dataUmum = querySnapshot.docs.first.data();
                final dataSpasial = doc.data();
                return {
                  ...dataUmum,
                  ...dataSpasial,
                };
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> selectLocation(
      LatLng point, BuildContext context) async {
    try {
      pickedLocation = point;

      // Hapus semua marker lama
      _markers.clear();

      // Tambahkan marker merah saja
      _markers.add(
        Marker(
          point: point,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      );

      mapController.move(point, 18.0);

      await Clipboard.setData(
        ClipboardData(text: '${point.latitude}, ${point.longitude}'),
      );

      notifyListeners();

      // Kamu bisa tetap kembalikan data terdekat jika mau, tapi tidak buat marker biru
      final nearbyData = await findNearbyData(point);
      return nearbyData;
    } catch (e) {
      debugPrint("Error in selectLocation: $e");
      return null;
    }
  }

  String? saveLocation() {
    if (pickedLocation != null) {
      return '${pickedLocation!.latitude},${pickedLocation!.longitude}';
    }
    return null;
  }

  Future<Map<String, dynamic>?> cariDanTampilkanLokasi(
      BuildContext context, String inputNamaLokasi) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('data_umum').get();
      final inputLower = inputNamaLokasi.toLowerCase();

      QueryDocumentSnapshot? matchingDoc;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final namaLokasi = data['nama_lokasi']?.toString().toLowerCase() ?? '';
        if (namaLokasi == inputLower) {
          matchingDoc = doc;
          break;
        }
      }

      if (matchingDoc != null) {
        final dataUmum = matchingDoc.data() as Map<String, dynamic>;
        final String? idDataSpasial = dataUmum['id_data_spasial'];

        if (idDataSpasial == null || idDataSpasial.isEmpty) {
          showCustomSnackbar(
            context: context,
            message: 'ID data spasial tidak ditemukan',
            isSuccess: false,
          );
          return null;
        }

        final dataSpasialSnapshot = await FirebaseFirestore.instance
            .collection('data_spasial')
            .doc(idDataSpasial)
            .get();

        if (!dataSpasialSnapshot.exists) {
          showCustomSnackbar(
            context: context,
            message: 'Data spasial tidak ditemukan',
            isSuccess: false,
          );
          return null;
        }

        final koordinatString = dataSpasialSnapshot['titik_koordinat'] ?? '';
        final coords = koordinatString.split(',');

        if (coords.length == 2) {
          final lat = double.tryParse(coords[0].trim());
          final lng = double.tryParse(coords[1].trim());

          if (lat != null && lng != null) {
            final selectedPoint = LatLng(lat, lng);

            pickedLocation = selectedPoint;

            _markers.clear();

            _markers.add(
              Marker(
                point: selectedPoint,
                width: 40,
                height: 40,
                child:
                    const Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            );

            notifyListeners();

            mapController.move(selectedPoint, 18.0);
            await Future.delayed(const Duration(milliseconds: 1200));

            return {
              ...dataUmum,
              ...?dataSpasialSnapshot.data(),
            };
          } else {
            showCustomSnackbar(
              context: context,
              message: 'Format koordinat tidak valid',
              isSuccess: false,
            );
          }
        } else {
          showCustomSnackbar(
            context: context,
            message: 'Format koordinat tidak valid',
            isSuccess: false,
          );
        }
      } else {
        showCustomSnackbar(
          context: context,
          message: 'Data tidak ditemukan',
          isSuccess: false,
        );
      }
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'Terjadi kesalahan: $e',
        isSuccess: false,
      );
    }
    return null;
  }

  Future<void> openOSMCopyrightLink(BuildContext context) async {
    final uri = Uri.parse('https://openstreetmap.org/copyright');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
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
  }

  void toggleSearch(bool value) {
    isSearching = value;
    notifyListeners();
  }

  void toggleCopyrightVisibility() {
    showCopyrightOSM = !showCopyrightOSM;
    notifyListeners();
  }
}
