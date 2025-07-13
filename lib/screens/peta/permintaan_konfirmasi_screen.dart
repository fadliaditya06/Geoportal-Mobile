import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum StatusKonfirmasi { disetujui, ditolak, menunggu }

class PermintaanKonfirmasiScreen extends StatefulWidget {
  const PermintaanKonfirmasiScreen({super.key});

  @override
  State<PermintaanKonfirmasiScreen> createState() =>
      _PermintaanKonfirmasiScreenState();
}

class _PermintaanKonfirmasiScreenState
    extends State<PermintaanKonfirmasiScreen> {
  StatusKonfirmasi statusTerpilih = StatusKonfirmasi.disetujui;

  String formatTanggal(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('d MMMM yyyy', 'id').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('Pengguna belum login'));
    }

    // Query firestore berdasarkan status terpilih dan uid user login
    final query = FirebaseFirestore.instance
        .collection('log_konfirmasi')
        .where('status', isEqualTo: statusTerpilih.name)
        .where('uid', isEqualTo: currentUser.uid)
        .orderBy('timestamp', descending: true);

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
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusButton(StatusKonfirmasi.disetujui, 'Disetujui'),
                _buildStatusButton(StatusKonfirmasi.menunggu, 'Menunggu'),
                _buildStatusButton(StatusKonfirmasi.ditolak, 'Ditolak'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: StreamBuilder<QuerySnapshot>(
                  stream: query.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 100),
                          Image.asset(
                            'assets/images/icon/permintaan-konfirmasi-kosong.png',
                            width: double.infinity,
                            height: 300,
                          ),
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              'Belum ada data yang dikonfirmasi',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    }

                    final docs = snapshot.data!.docs;

                    // Menampilkan setiap data konfirmasi ke dalam card
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(30),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final nestedData =
                            data['data'] as Map<String, dynamic>?;

                        final nama = data['nama'] ?? '-';
                        final deskripsi = data['deskripsi'] ?? '-';
                        final status = data['status'] ?? '';
                        final alasanList =
                            data['alasan'] as List<dynamic>? ?? [];
                        final alasanGabungan = alasanList.join(', ');
                        final tanggal = data['timestamp'] as Timestamp;
                        final idDataUmum = nestedData?['id_data_umum'];

                        if (idDataUmum == null) {
                          return ListTile(
                            title: Text(nama),
                            subtitle: const Text('ID data umum tidak tersedia'),
                          );
                        }

                        return FutureBuilder<DocumentSnapshot>(
                          future:
                              FirebaseFirestore.instance
                                  .collection('data_umum')
                                  .doc(idDataUmum)
                                  .get(),
                          builder: (context, snapshotDataUmum) {
                            String lokasi = 'Memuat lokasi';

                            if (snapshotDataUmum.connectionState ==
                                ConnectionState.done) {
                              if (snapshotDataUmum.hasData &&
                                  snapshotDataUmum.data!.exists) {
                                final dataUmum =
                                    snapshotDataUmum.data!.data()
                                        as Map<String, dynamic>;
                                lokasi =
                                    dataUmum['nama_lokasi'] ??
                                    'Tidak ada nama lokasi';
                              } else {
                                lokasi = 'Data lokasi tidak ditemukan';
                              }
                            }

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF358666),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                        future:
                                            FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(data['uid'])
                                                .get(),
                                        builder: (context, snapshotUser) {
                                          String? fotoProfil;
                                          if (snapshotUser.connectionState ==
                                                  ConnectionState.done &&
                                              snapshotUser.hasData &&
                                              snapshotUser.data!.exists) {
                                            final userData =
                                                snapshotUser.data!.data()
                                                    as Map<String, dynamic>;
                                            fotoProfil =
                                                userData['foto_profil']
                                                    as String?;
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
                                                  (fotoProfil != null &&
                                                          fotoProfil.isNotEmpty)
                                                      ? NetworkImage(fotoProfil)
                                                      : null,
                                              child:
                                                  (fotoProfil == null ||
                                                          fotoProfil.isEmpty)
                                                      ? Icon(
                                                        Icons.person,
                                                        size: 30,
                                                        color: Colors.grey[700],
                                                      )
                                                      : null,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              nama,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            // Menampilkan detail dari status permintaan konfirmasi
                                            Text(
                                              () {
                                                if (status == 'ditolak' &&
                                                    alasanGabungan.isNotEmpty) {
                                                  return 'Ditolak - $alasanGabungan';
                                                } else if (status ==
                                                    'menunggu') {
                                                  final desc =
                                                      deskripsi.toLowerCase();
                                                  if (desc.contains('hapus')) {
                                                    return 'Menunggu Konfirmasi Hapus Data';
                                                  } else if (desc.contains(
                                                    'tambah',
                                                  )) {
                                                    return 'Menunggu Konfirmasi Tambah Data';
                                                  } else if (desc.contains(
                                                    'ubah',
                                                  )) {
                                                    return 'Menunggu Konfirmasi Ubah Data';
                                                  } else {
                                                    return 'Menunggu Konfirmasi';
                                                  }
                                                } else {
                                                  return _statusLabel(status);
                                                }
                                              }(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              lokasi,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.description,
                                                      size: 18,
                                                      color: Color(0xFF358666),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    Colors
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Permintaan Konfirmasi ',
                                                              style: GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  deskripsi
                                                                          .toLowerCase()
                                                                          .contains(
                                                                            'hapus',
                                                                          )
                                                                      ? 'Hapus'
                                                                      : deskripsi
                                                                          .toLowerCase()
                                                                          .contains(
                                                                            'tambah',
                                                                          )
                                                                      ? 'Tambah'
                                                                      : deskripsi
                                                                          .toLowerCase()
                                                                          .contains(
                                                                            'ubah',
                                                                          )
                                                                      ? 'Ubah'
                                                                      : '',
                                                              style: GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            const TextSpan(
                                                              text: '\n',
                                                            ),
                                                            TextSpan(
                                                              text: 'Data',
                                                              style: GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time_filled,
                                                  size: 16,
                                                  color: Color(0xFF358666),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  formatTanggal(tanggal),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(StatusKonfirmasi status, String label) {
    final isSelected = statusTerpilih == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          statusTerpilih = status;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF358666) : const Color(0xFFB0E1C6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF358666),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'disetujui':
        return 'Disetujui';
      case 'ditolak':
        return 'Ditolak';
      case 'menunggu':
        return 'Menunggu Konfirmasi';
      default:
        return status;
    }
  }
}
