import 'package:flutter/material.dart';
import 'package:geoportal_mobile/screens/peta/ubah_data_screen.dart';

class DetailDataBottomSheet extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailDataBottomSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                const Center(
                  child: Text("Identifikasi",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 16),
                _buildDataRow("Nama Lokasi", data["nama_lokasi"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Pemilik", data["pemilik"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Publikasi", data["publikasi"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Jenis Sumber Daya", data["jenis_sumber_daya"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Sumber", data["sumber"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildFotoRow(data["foto_lokasi"]),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 20),
                const Center(
                  child: Text("Informasi Spasial",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Sistem Proyeksi", data["sistem_proyeksi"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Titik Koordinat", data["titik_koordinat"]),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 24),

                // Tombol Ubah Data
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF92E3A9),
                      foregroundColor: Colors.black,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.edit_location_alt,
                        size: 18, color: Color(0xFF358666)),
                    label: const Text("Ubah Data"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UbahDataScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
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

  Widget _buildFotoRow(dynamic fotoData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Foto",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),
          if (fotoData is String)
            SizedBox(
              width: double.infinity,
              child: Image.network(
                fotoData,
                width: 360,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Gagal memuat gambar');
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            )
          else if (fotoData is List)
            SizedBox(
              width: 360,
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fotoData.length,
                itemBuilder: (context, index) {
                  final fotoUrl = fotoData[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        fotoUrl,
                        width: 360,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Gagal memuat gambar');
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Text('Tidak ada foto'),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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
            child: value is Widget ? value : Text(value?.toString() ?? "-"),
          ),
        ],
      ),
    );
  }
}
