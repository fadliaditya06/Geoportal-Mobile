import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;

class DetailPetaScreen extends StatefulWidget {
  const DetailPetaScreen({super.key});

  @override
  State<DetailPetaScreen> createState() => _DetailPetaScreenState();
}

class _DetailPetaScreenState extends State<DetailPetaScreen> {
  // Fungsi untuk memilih koordinat yang dipilih
  latlng.LatLng? _pickedLocation;
  // Fungsi untuk pemilihan lokasi yang dipilih dan menyalin koordinat ke clipboard
  void _selectLocation(latlng.LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
    // Salin koordinat ke clipboard
    Clipboard.setData(
      ClipboardData(
        text: '${position.latitude}, ${position.longitude}',
      ),
    );

    // Snackbar untuk menampilkan data koordinat yang dipilih
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF92E3A9),
        content: Text(
          'Koordinat disalin: ${position.latitude}, ${position.longitude}',
          style: const TextStyle(color: Colors.black),
        ),
        // duration: const Duration(seconds: 2), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        // Lokasi koordinat awal peta
        options: MapOptions(
          initialCenter: const latlng.LatLng(1.13, 104.0531),
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
          // Menampilkan marker pada peta
          if (_pickedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  // Menempatkan marker pada koordinat yang dipilih
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
    );
  }
}
