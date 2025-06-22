import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'package:geoportal_mobile/widgets/dummy_bottom_sheet.dart';
import 'package:geoportal_mobile/services/geojson_service.dart';

class DetailPetaController with ChangeNotifier {
  final MapController mapController = MapController();

  final List<Marker> _markers = [];
  final List<Polygon> _polygons = [];
  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  bool isSearching = false;
  bool showCopyrightOSM = false;
  LatLng? pickedLocation;

  List<Marker> get markers => _markers;
  List<Polygon> get polygons => _polygons;

  // Fungsi memuat GeoJSON dari URL Supabase Storage
  // Future<void> loadGeoJsonMultiple(BuildContext context) async {
  //   const String url =
  //       'https://noeywxxoxuyicxtcsier.supabase.co/storage/v1/object/public/images/geojson/lubuk_baja.geojson';

  //   try {
  //     isLoading = true;
  //     notifyListeners();

  //     _markers.clear();
  //     _polygons.clear();

  //     // Ambil dan batasi jumlah polygon dan marker
  //     final polygons = await GeoJsonService.loadPolygons(url);
  //     final markersData = await GeoJsonService.loadMarkers(
  //       url,
  //       context,
  //       _buildMarker,
  //     );

  //     // Membuat minimal marker dan polygon agar tidak crash
  //     _polygons.addAll(polygons.take(500));
  //     _markers.addAll(markersData.take(500));
  //   } catch (e) {
  //     debugPrint('Gagal load GeoJSON: $e');
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Fungsi memuat GeoJSON dari asset
  Future<void> loadGeoJsonMultiple(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      _markers.clear();
      _polygons.clear();

      // Load daftar file dari index.json
      final String indexData = await rootBundle
          .loadString('assets/geojson/dummy-geojson/index.json');
      final List<dynamic> fileList = jsonDecode(indexData);

      for (final fileName in fileList) {
        final String assetPath = 'assets/geojson/dummy-geojson/$fileName';

        // Muat polygon dari asset
        final polygons = await GeoJsonService.loadPolygonsFromAsset(assetPath);
        final markers = await GeoJsonService.loadMarkersFromAsset(
          assetPath,
          context,
          _buildMarker,
        );

        _polygons.addAll(polygons.take(2000));
        _markers.addAll(markers.take(2000));
      }
    } catch (e) {
      debugPrint('Gagal load GeoJSON dari assets: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi membangun marker
  Marker _buildMarker(
      LatLng position, Map<String, dynamic> feature, BuildContext context) {
    return Marker(
      point: position,
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => _showDynamicBottomSheet(context, feature),
      ),
    );
  }

  // BottomSheet untuk menampilkan properti dari fitur GeoJSON
  void _showDynamicBottomSheet(
      BuildContext context, Map<String, dynamic> feature) {
    final properties = feature['properties'] as Map<String, dynamic>? ?? {};
    final geometry = feature['geometry'] as Map<String, dynamic>? ?? {};

    String coordinatesText = '-';
    final rawCoordinates = geometry['coordinates'];
    if (rawCoordinates is List && rawCoordinates.isNotEmpty) {
      final polygonPoints = rawCoordinates[0];
      if (polygonPoints is List && polygonPoints.isNotEmpty) {
        final point = polygonPoints[0];
        coordinatesText = 'Lat: ${point[1]}, Lng: ${point[0]}';
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DummyBottomSheet(
        kelurahan: (properties['Kelurahan'] ?? '').toString(),
        kecamatan: (properties['Kecamatan'] ?? '').toString(),
        kawasan: (properties['Kawasan'] ?? '').toString(),
        lokasi: (properties['Lokasi'] ?? '').toString(),
        alamat: (properties['Alamat'] ?? 'Tidak ada data').toString(),
        rt: (properties['RT'] ?? 0).toString(),
        rw: (properties['RW'] ?? 0).toString(),
        shapeLength: properties['Shape_Leng'].toString(),
        shapeArea: properties['Shape_Area'].toString(),
        coordinates: coordinatesText,
      ),
    );
  }

  // Menentukan lokasi berdasarkan tap di peta dan cari data terdekat
  Future<Map<String, dynamic>?> selectLocation(
      LatLng point, BuildContext context) async {
    pickedLocation = point;
    _markers.clear();

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
        ClipboardData(text: '${point.latitude}, ${point.longitude}'));

    notifyListeners();

    return await findNearbyData(point);
  }

  // Mencari data spasial terdekat dari Firestore
  Future<Map<String, dynamic>?> findNearbyData(LatLng point) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('data_spasial')
          .where('status', isEqualTo: 'disetujui')
          .get();

      const double toleranceMeters = 50;

      for (var doc in snapshot.docs) {
        final coords = (doc['titik_koordinat'] ?? '').split(',');
        if (coords.length != 2) continue;

        final lat = double.tryParse(coords[0].trim());
        final lng = double.tryParse(coords[1].trim());

        if (lat != null && lng != null) {
          final firestorePoint = LatLng(lat, lng);
          final distance =
              const Distance().as(LengthUnit.Meter, point, firestorePoint);

          if (distance <= toleranceMeters) {
            final id = doc.id;

            final dataUmumSnapshot = await FirebaseFirestore.instance
                .collection('data_umum')
                .where('id_data_spasial', isEqualTo: id)
                .get();

            if (dataUmumSnapshot.docs.isNotEmpty) {
              return {
                ...dataUmumSnapshot.docs.first.data(),
                ...doc.data(),
              };
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error saat mencari data terdekat: $e");
    }
    return null;
  }

  // Simpan lokasi terpilih
  String? saveLocation() {
    return pickedLocation != null
        ? '${pickedLocation!.latitude},${pickedLocation!.longitude}'
        : null;
  }

  // Cari lokasi berdasarkan nama dan tampilkan di peta
  Future<Map<String, dynamic>?> cariDanTampilkanLokasi(
      BuildContext context, String inputNamaLokasi) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('data_umum').get();
      final namaDicari = inputNamaLokasi.toLowerCase();

      for (var doc in snapshot.docs) {
        final nama = doc['nama_lokasi']?.toString().toLowerCase() ?? '';
        if (nama == namaDicari) {
          final idSpasial = doc['id_data_spasial'];
          if (idSpasial == null || idSpasial.isEmpty) {
            showCustomSnackbar(
                context: context,
                message: 'ID spasial tidak ditemukan',
                isSuccess: false);
            return null;
          }

          final spasialDoc = await FirebaseFirestore.instance
              .collection('data_spasial')
              .doc(idSpasial)
              .get();

          if (!spasialDoc.exists || spasialDoc['status'] != 'disetujui') {
            showCustomSnackbar(
                context: context,
                message: 'Data tidak disetujui',
                isSuccess: false);
            return null;
          }

          final coords = (spasialDoc['titik_koordinat'] ?? '').split(',');
          if (coords.length == 2) {
            final lat = double.tryParse(coords[0].trim());
            final lng = double.tryParse(coords[1].trim());

            if (lat != null && lng != null) {
              final point = LatLng(lat, lng);
              pickedLocation = point;

              _markers.clear();
              _markers.add(Marker(
                point: point,
                width: 40,
                height: 40,
                child:
                    const Icon(Icons.location_on, color: Colors.red, size: 40),
              ));

              mapController.move(point, 18.0);
              notifyListeners();

              return {
                ...doc.data(),
                ...spasialDoc.data()!,
              };
            }
          }

          showCustomSnackbar(
              context: context,
              message: 'Koordinat tidak valid',
              isSuccess: false);
          return null;
        }
      }

      showCustomSnackbar(
          context: context, message: 'Data tidak ditemukan', isSuccess: false);
    } catch (e) {
      showCustomSnackbar(
          context: context, message: 'Error: $e', isSuccess: false);
    }
    return null;
  }

  // Menyediakan saran pencarian
  Future<List<String>> getSuggestions(String query) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('data_umum').get();
    final input = query.toLowerCase();
    List<String> hasil = [];

    for (var doc in snapshot.docs) {
      final nama = doc['nama_lokasi']?.toString().toLowerCase() ?? '';
      final id = doc['id_data_spasial'];
      if (id == null) continue;

      final spasialDoc = await FirebaseFirestore.instance
          .collection('data_spasial')
          .doc(id)
          .get();

      if (spasialDoc.exists &&
          spasialDoc['status'] == 'disetujui' &&
          nama.contains(input)) {
        hasil.add(doc['nama_lokasi']);
      }
    }

    return hasil;
  }

  // Toggle tampilan hak cipta OSM
  void toggleCopyrightVisibility() {
    showCopyrightOSM = !showCopyrightOSM;
    notifyListeners();
  }

  // Buka link OSM
  Future<void> openOSMCopyrightLink(BuildContext context) async {
    final uri = Uri.parse('https://openstreetmap.org/copyright');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        showCustomSnackbar(
            context: context,
            message: 'Tidak dapat membuka tautan',
            isSuccess: false);
      }
    } catch (_) {
      showCustomSnackbar(
          context: context, message: 'Gagal membuka tautan', isSuccess: false);
    }
  }

  // Buka link Esri
  Future<void> openEsriCopyrightLink(BuildContext context) async {
    final uri = Uri.parse(
        'https://www.arcgis.com/home/item.html?id=10df2279f9684e4a9f6a7f08febac2a9');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        showCustomSnackbar(
            context: context,
            message: 'Tidak dapat membuka tautan',
            isSuccess: false);
      }
    } catch (_) {
      showCustomSnackbar(
          context: context, message: 'Gagal membuka tautan', isSuccess: false);
    }
  }

  void toggleSearch(bool value) {
    isSearching = value;
    notifyListeners();
  }
}
