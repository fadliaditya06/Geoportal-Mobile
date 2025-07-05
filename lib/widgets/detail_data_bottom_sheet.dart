import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geoportal_mobile/screens/peta/ubah_data_screen.dart';
import 'package:geoportal_mobile/controllers/unduh_data_controller.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoportal_mobile/models/log_konfirmasi_model.dart';
import 'package:geoportal_mobile/screens/modal/hapus_data_modal.dart';

class DetailDataBottomSheet extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailDataBottomSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        key: const Key('bottomSheetDetailData'),
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
                            child: Icon(Icons.close,
                                color: Colors.black, size: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Informasi Data Umum dan Spasial
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
                  // Tombol Ubah Data
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          key: const Key('btnUbahData'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF92E3A9),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UbahDataScreen(
                                  idDataUmum: data['id_data_umum'],
                                  idDataSpasial: data['id_data_spasial'],
                                  data: data,
                                ),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.edit_location_alt,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 70),
                        // Tombol Hapus Data
                        ElevatedButton(
                          key: const Key('btnHapusData'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEA3535),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) return;

                            final userDoc = await FirebaseFirestore.instance
                                .collection('user')
                                .doc(user.uid)
                                .get();

                            final namaUser = userDoc['nama'] ?? 'Pengguna';
                            final peranUser = userDoc['peran'] ?? 'pengguna';

                            final idDataUmum = data['id_data_umum'];
                            final idDataSpasial = data['id_data_spasial'];

                            if (idDataUmum == null || idDataSpasial == null) {
                              showCustomSnackbar(
                                context: context,
                                message: 'Data tidak lengkap',
                                isSuccess: false,
                              );
                              return;
                            }

                            await showDeleteDataDialog(
                              context: context,
                              onConfirm: () async {
                                // Jika role admin maka tidak memerlukan konfirmasi
                                if (peranUser.toLowerCase() == 'admin') {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('data_umum')
                                        .doc(idDataUmum)
                                        .delete();

                                    await FirebaseFirestore.instance
                                        .collection('data_spasial')
                                        .doc(idDataSpasial)
                                        .delete();

                                    Navigator.pop(context);
                                    showCustomSnackbar(
                                      context: context,
                                      message:
                                          'Data berhasil dihapus oleh admin',
                                      isSuccess: true,
                                    );
                                  } catch (e) {
                                    showCustomSnackbar(
                                      context: context,
                                      message: 'Gagal menghapus data: $e',
                                      isSuccess: false,
                                    );
                                  }
                                } else {
                                  // Jika role pengguna, maka memerlukan konfirmasi
                                  final log = LogKonfirmasiModel(
                                    uid: user.uid,
                                    nama: namaUser,
                                    peran: peranUser,
                                    deskripsi:
                                        'Permintaan Konfirmasi Hapus Data',
                                    status: 'menunggu',
                                    timestamp: Timestamp.now(),
                                    data: {
                                      'id_data_umum': idDataUmum,
                                      'id_data_spasial': idDataSpasial,
                                    },
                                  );

                                  await FirebaseFirestore.instance
                                      .collection('log_konfirmasi')
                                      .add(log.toMap());

                                  Navigator.pop(context);
                                  showCustomSnackbar(
                                    context: context,
                                    message:
                                        'Permintaan hapus data berhasil diajukan',
                                    isSuccess: true,
                                  );
                                }
                              },
                            );
                          },
                          child: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 80),
                        // Tombol Unduh Data
                        Consumer<UnduhDataController>(
                          builder: (context, c, _) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF92E3A9),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                              ),
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
                                          message:
                                              'File telah berhasil diunduh',
                                          isSuccess: true,
                                        );
                                      }

                                      Navigator.pop(context);
                                    },
                              child: c.loadingPdf
                                  ? const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.download,
                                      size: 18, color: Colors.black),
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
