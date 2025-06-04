import 'package:flutter/material.dart';

class DummyBottomSheet extends StatelessWidget {
  final String fclass;
  final String name;
  final int code;
  final int population;
  final String osmId;
  final String coordinates;

  const DummyBottomSheet({
    super.key,
    required this.fclass,
    required this.name,
    required this.code,
    required this.population,
    required this.osmId,
    required this.coordinates,
  });

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

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
                // Garis hitam di tengah atas
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
                    '${_capitalize(fclass)}: $name',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 16),
                _buildDataRow("Kode", code.toString()),
                const Divider(thickness: 1, color: Colors.black),
                if (population > 0) ...[
                  _buildDataRow("Populasi", population.toString()),
                  const Divider(thickness: 1, color: Colors.black),
                ],
                _buildDataRow("OSM ID", osmId.toString()),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Titik Koordinat", coordinates),
                const SizedBox(height: 24),
              ],
            ),
          ),
          // Tombol silang di kanan atas
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
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 20,
                  ),
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
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
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
