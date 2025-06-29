import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'package:geoportal_mobile/screens/modal/permintaan_disetujui_modal.dart';
import 'package:geoportal_mobile/screens/modal/permintaan_ditolak_modal.dart';

class PermintaanKonfirmasiAdminScreen extends StatefulWidget {
  const PermintaanKonfirmasiAdminScreen({super.key});

  @override
  PermintaanKonfirmasiAdminScreenState createState() =>
      PermintaanKonfirmasiAdminScreenState();
}

class PermintaanKonfirmasiAdminScreenState
    extends State<PermintaanKonfirmasiAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Permintaan Konfirmasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.36, 0.76, 1.0],
            colors: [
              Color(0xFFB0E1C6),
              Color(0xFFFFFFFF),
              Color(0xFF72B396),
              Color(0xFF358666),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('log_konfirmasi')
                .where('status', isEqualTo: 'menunggu')
                // .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 100),
                      Image.asset(
                        'assets/images/icon/permintaan-konfirmasi-kosong.png',
                        width: double.infinity,
                        height: 300,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Tidak ada permintaan konfirmasi data',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final docId = docs[index].id;

                  final nama = data['nama'] ?? '-';
                  final deskripsi = data['deskripsi'] ?? '-';
                  final waktu = data['timestamp'] != null
                      ? DateFormat('dd MMMM yyyy - HH:mm', 'id')
                          .format((data['timestamp'] as Timestamp).toDate())
                      : '-';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detail-konfirmasi',
                                arguments: {
                                  'id_data_umum': data['data']?['id_data_umum'],
                                  'id_data_spasial': data['data']
                                      ?['id_data_spasial'],
                                  'uid': data['uid'],
                                  'deskripsi': data['deskripsi'],
                                  'docId': docId,
                                },
                              );
                            },
                            child: _permintaanKonfirmasiCard(
                              uid: data['uid'] ?? '-',
                              title: nama,
                              description: '$deskripsi\n$waktu',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: GestureDetector(
                                onTap: () {
                                  showPermintaanDisetujuiDialog(
                                    context: context,
                                    deskripsi: data['deskripsi'] ?? '',
                                    onConfirm: () =>
                                        _updateStatus(docId, 'disetujui'),
                                  );
                                },
                                child: _permintaanKonfirmasiIcon(
                                  icon: CupertinoIcons.checkmark_alt,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: GestureDetector(
                                onTap: () async {
                                  late String jenisPermintaan;

                                  final deskripsiLower =
                                      deskripsi.toLowerCase();
                                  if (deskripsiLower.contains('hapus')) {
                                    jenisPermintaan = 'hapus';
                                  } else if (deskripsiLower
                                      .contains('tambah')) {
                                    jenisPermintaan = 'tambah';
                                  } else if (deskripsiLower.contains('ubah')) {
                                    jenisPermintaan = 'ubah';
                                  } else {
                                    jenisPermintaan = 'lainnya';
                                  }

                                  await showPenolakanDialogDinamis(
                                    context: context,
                                    jenisPermintaan: jenisPermintaan,
                                    onConfirm: (alasanList) async {
                                      await _updateStatus(
                                          docId, 'ditolak', alasanList);
                                    },
                                  );
                                },
                                child: _permintaanKonfirmasiIcon(
                                  icon: Icons.close,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Fungsi untuk update status konfirmasi dan update data spasial
  Future<void> _updateStatus(String docId, String status,
      [List<String>? alasan]) async {
    try {
      final logDoc = await FirebaseFirestore.instance
          .collection('log_konfirmasi')
          .doc(docId)
          .get();

      if (!logDoc.exists) {
        showCustomSnackbar(
          context: context,
          message: 'Data log konfirmasi tidak ditemukan',
          isSuccess: false,
        );
        return;
      }

      final data = logDoc.data();
      final idDataSpasial = data?['data']?['id_data_spasial'];
      final idDataUmum = data?['data']?['id_data_umum'];
      final deskripsi = (data?['deskripsi'] ?? '').toString().toLowerCase();
      final dataBaru = data?['data_baru'];

      // Update status dan alasan di log konfirmasi
      final Map<String, dynamic> updateData = {
        'status': status,
        'updated_at': DateTime.now(),
      };
      if (alasan != null && alasan.isNotEmpty) {
        updateData['alasan'] = alasan;
      }

      await FirebaseFirestore.instance
          .collection('log_konfirmasi')
          .doc(docId)
          .update(updateData);

      // Jika hapus data disetujui maka hapus data
      if (status == 'disetujui') {
        if (deskripsi.contains('hapus') &&
            idDataSpasial != null &&
            idDataUmum != null) {
          await FirebaseFirestore.instance
              .collection('data_umum')
              .doc(idDataUmum)
              .delete();
          await FirebaseFirestore.instance
              .collection('data_spasial')
              .doc(idDataSpasial)
              .delete();
          // Ubah data
        } else if (deskripsi.contains('ubah') &&
            dataBaru != null &&
            idDataSpasial != null &&
            idDataUmum != null) {
          final baru = Map<String, dynamic>.from(dataBaru);

          // Update data spasial
          await FirebaseFirestore.instance
              .collection('data_spasial')
              .doc(idDataSpasial)
              .update({
            'titik_koordinat': baru['titik_koordinat'],
            'status': 'disetujui',
            'updated_at': DateTime.now(),
          });

          // Update data umum
          await FirebaseFirestore.instance
              .collection('data_umum')
              .doc(idDataUmum)
              .update({
            'nama_lokasi': baru['nama_lokasi'],
            'kelurahan': baru['kelurahan'],
            'kecamatan': baru['kecamatan'],
            'kawasan': baru['kawasan'],
            'alamat': baru['alamat'],
            'rt': baru['rt'],
            'rw': baru['rw'],
            'panjang_bentuk': baru['panjang_bentuk'],
            'luas_bentuk': baru['luas_bentuk'],
            'foto_lokasi': baru['foto_lokasi'],
            'updated_at': DateTime.now(),
          });
        } else if (deskripsi.contains('tambah') && idDataSpasial != null) {
          // Jika tambah data disetujui
          await FirebaseFirestore.instance
              .collection('data_spasial')
              .doc(idDataSpasial)
              .update({
            'status': 'disetujui',
            'updated_at': DateTime.now(),
          });
        }
      }

      // Jika tambah data ditolak maka hapus data
      else if (status == 'ditolak') {
        if (deskripsi.contains('tambah') &&
            idDataSpasial != null &&
            idDataUmum != null) {
          await FirebaseFirestore.instance
              .collection('data_umum')
              .doc(idDataUmum)
              .delete();
          await FirebaseFirestore.instance
              .collection('data_spasial')
              .doc(idDataSpasial)
              .delete();
        } else {}
      }

      showCustomSnackbar(
        context: context,
        message: 'Konfirmasi data berhasil $status',
        isSuccess: true,
      );
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'Gagal mengupdate status: $e',
        isSuccess: false,
      );
    }
  }

  // Card tampilan permintaan konfirmasi
  Widget _permintaanKonfirmasiCard({
    required String title,
    required String description,
    required String uid,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF358666)),
      ),
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar user menggunakan FutureBuilder
            FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance.collection('user').doc(uid).get(),
              builder: (context, snapshotUser) {
                String? fotoProfil;
                if (snapshotUser.connectionState == ConnectionState.done &&
                    snapshotUser.hasData &&
                    snapshotUser.data!.exists) {
                  final userData =
                      snapshotUser.data!.data() as Map<String, dynamic>;
                  fotoProfil = userData['foto_profil'] as String?;
                }

                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF358666),
                      width: 1,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        (fotoProfil != null && fotoProfil.isNotEmpty)
                            ? NetworkImage(fotoProfil)
                            : null,
                    child: (fotoProfil == null || fotoProfil.isEmpty)
                        ? Icon(Icons.person, size: 30, color: Colors.grey[700])
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),

            // Bagian teks
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description.split('\n').first,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description.split('\n').last,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Icon ACC dan Tolak
  Widget _permintaanKonfirmasiIcon({required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFB0E1C6),
        border: Border.all(
          color: const Color(0xFF358666),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(icon, size: 22, color: Colors.black),
    );
  }
}
