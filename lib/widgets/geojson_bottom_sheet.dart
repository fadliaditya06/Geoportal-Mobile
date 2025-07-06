import 'package:flutter/material.dart';
import 'package:geoportal_mobile/models/geojson_model.dart';

class GeoJSONBottomSheet extends StatelessWidget {
  final GeoJSONDataModel data;

  const GeoJSONBottomSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: SizedBox(
                    width: 40,
                    height: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    data.lokasi.isNotEmpty ? data.lokasi : 'Detail Lokasi',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 16),
                _buildDataRow("Kelurahan", data.kelurahan),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Kecamatan", data.kecamatan),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Kawasan", data.kawasan),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Alamat", data.alamat),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("RT/RW", '${data.rt}/${data.rw}'),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Panjang Bentuk", data.shapeLength),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Luas Bentuk", data.shapeArea),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Koordinat", data.coordinates),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 0,
            child: Material(
              shape: const CircleBorder(),
              elevation: 4,
              color: Colors.white,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.close, color: Colors.black, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w400)),
          ),
          Expanded(
            flex: 6,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
