import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoportal_mobile/models/permintaan_konfirmasi_model.dart';
import 'package:intl/intl.dart';

class PermintaanKonfirmasiScreen extends StatefulWidget {
  const PermintaanKonfirmasiScreen({super.key});

  @override
  State<PermintaanKonfirmasiScreen> createState() =>
      _PermintaanKonfirmasiScreenState();
}

class _PermintaanKonfirmasiScreenState
    extends State<PermintaanKonfirmasiScreen> {
  bool isDisetujui = true;

  String formatTanggal(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final data = PermintaanKonfirmasiModel.dummyDataKonfirmasi;

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
      // Gradien Background
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.6, 1.0],
            colors: [
              const Color(0xFFB0E1C6),
              const Color(0xFFFFFFFF).withOpacity(0.36),
              const Color(0xFF72B396).withOpacity(0.76),
              const Color(0xFF358666).withOpacity(0.98),
            ],
          ),
        ),
        // Kotak untuk Permintaan Konfirmasi
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  isDisetujui = !isDisetujui;
                });
              },
              child: Container(
                width: 343,
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isDisetujui
                      ? const Color(0xFF358666)
                      : const Color(0xFFB0E1C6),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: isDisetujui
                      ? const [
                          Text(
                            'Disetujui',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              color: Colors.black, size: 30),
                        ]
                      : const [
                          Icon(Icons.chevron_left,
                              color: Colors.black, size: 30),
                          Text(
                            'Ditolak',
                            style: TextStyle(
                              color: Color(0xFF358666),
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                ),
              ),
            ),
            // ListView Permintaan Konfirmasi
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(30),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];

                  // Logika filtering berdasarkan string dalam status
                  final isStatusDisetujui =
                      item.status.toLowerCase().contains('disetujui');
                  final isStatusDitolak =
                      item.status.toLowerCase().contains('ditolak');

                  // Filter berdasarkan toggle
                  if ((isDisetujui && !isStatusDisetujui) ||
                      (!isDisetujui && !isStatusDitolak)) {
                    return const SizedBox.shrink();
                  }
                  // Card dan Informasi Permintaan Konfirmasi
                  return SizedBox(
                    child: Card(
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
                        // Foto Profil
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
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
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Detail Data Permintaan Konfirmasi
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.status,
                                      style: TextStyle(
                                        color: isStatusDisetujui
                                            ? Colors.black
                                            : Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.lokasi,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(CupertinoIcons.doc_fill,
                                            size: 18, color: Color(0xFF358666)),
                                        const SizedBox(width: 6),
                                        Text(
                                          item.jenisPermintaan,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time,
                                            size: 18, color: Color(0xFF358666)),
                                        const SizedBox(width: 6),
                                        Text(
                                          formatTanggal(item.tanggalPermintaan),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
