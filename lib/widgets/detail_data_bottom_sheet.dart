import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geoportal_mobile/screens/peta/ubah_data_screen.dart';
import 'package:geoportal_mobile/controllers/unduh_data_controller.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';

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
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      shape: const CircleBorder(),
                      elevation: 4,
                      color: Colors.white,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child:
                              Icon(Icons.close, color: Colors.black, size: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    "Identifikasi",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 16),
                _buildDataRow("Nama Lokasi", data["nama_lokasi"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Kelurahan", data["kelurahan"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Kecamatan", data["kecamatan"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Kawasan", data["kawasan"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Alamat", data["alamat"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("RT/RW", "${data['rt']}/${data['rw']}"),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Panjang Bentuk", data["panjang_bentuk"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Luas Bentuk", data["luas_bentuk"]),
                const Divider(thickness: 1, color: Colors.black),
                _buildFotoRow(data["foto_lokasi"]),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Informasi Spasial",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black),
                _buildDataRow("Titik Koordinat", data["titik_koordinat"]),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF92E3A9),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.edit_location_alt,
                            size: 18, color: Colors.black),
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
                      const SizedBox(width: 40),
                      Consumer<UnduhDataController>(
                        builder: (context, c, _) {
                          return ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF92E3A9),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            icon: c.loadingPdf
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.download,
                                    size: 18, color: Colors.black),
                            label: const Text("Unduh Data"),
                            onPressed: c.loadingPdf
                                ? null
                                : () async {
                                    final controller =
                                        Provider.of<UnduhDataController>(
                                      context,
                                      listen: false,
                                    );

                                    controller.setLoading(true);

                                    final namaLokasi = data["nama_lokasi"];
                                    controller.selectedLokasi = namaLokasi;

                                    await controller
                                        .fetchDataByNamaLokasi(namaLokasi);
                                    await controller.downloadAndGeneratePDF();

                                    controller.setLoading(false);

                                    if (controller.savedFilePath != null) {
                                      showCustomSnackbar(
                                        context: context,
                                        message: 'File telah berhasil diunduh',
                                        isSuccess: true,
                                      );
                                    }
                                    Navigator.pop(context);
                                  },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
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
                            child: CircularProgressIndicator(),
                          );
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
