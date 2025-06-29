import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailKonfirmasiDataScreen extends StatefulWidget {
  const DetailKonfirmasiDataScreen({super.key});

  @override
  DetailKonfirmasiDataScreenState createState() =>
      DetailKonfirmasiDataScreenState();
}

class DetailKonfirmasiDataScreenState
    extends State<DetailKonfirmasiDataScreen> {
  final Map<String, bool> _imageVisibilityMap = {};
  Map<String, dynamic>? dataUmum;
  Map<String, dynamic>? dataSpasial;
  Map<String, dynamic>? user;
  bool isLoading = true;
  String? deskripsi;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final idUmum = args['id_data_umum'];
    final idSpasial = args['id_data_spasial'];
    final uid = args['uid'];
    deskripsi = args['deskripsi'];
    final docId = args['docId'];
    _fetchAllData(idUmum, idSpasial, uid, docId);
  }

  Future<void> _fetchAllData(
      String idUmum, String idSpasial, String uid, String docId) async {
    try {
      final docUmum = await FirebaseFirestore.instance
          .collection('data_umum')
          .doc(idUmum)
          .get();
      final docSpasial = await FirebaseFirestore.instance
          .collection('data_spasial')
          .doc(idSpasial)
          .get();
      final docUser =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      final docLog = await FirebaseFirestore.instance
          .collection('log_konfirmasi')
          .doc(docId)
          .get();

      final dataBaru = docLog.data()?['data_baru'];

      // Gabungkan jika ada data baru
      Map<String, dynamic>? finalDataUmum = docUmum.data();
      Map<String, dynamic>? finalDataSpasial = docSpasial.data();

      if (dataBaru != null) {
        final baru = Map<String, dynamic>.from(dataBaru);
        finalDataUmum = {
          ...finalDataUmum ?? {},
          ...baru,
        };
        finalDataSpasial = {
          ...finalDataSpasial ?? {},
          'titik_koordinat': baru['titik_koordinat'],
        };
      }

      setState(() {
        dataUmum = finalDataUmum;
        dataSpasial = finalDataSpasial;
        user = docUser.data();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat data: $e');
      setState(() => isLoading = false);
    }
  }

  String _labelJenisPermintaan(String deskripsi) {
    if (deskripsi.toLowerCase().contains('hapus')) {
      return 'Hapus';
    } else if (deskripsi.toLowerCase().contains('tambah')) {
      return 'Tambah';
    } else if (deskripsi.toLowerCase().contains('ubah')) {
      return 'Ubah';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Detail Data",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.36, 0.76, 0.93],
                  colors: [
                    Color(0xFFB0E1C6),
                    Color(0xFFFFFFFF),
                    Color(0xFF72B396),
                    Color(0xFFFFFFFF),
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserCard(),
                      const SizedBox(height: 16),
                      _buildHeaderInfo(),
                      const SizedBox(height: 20),
                      _buildIdentifikasiCard(),
                      const SizedBox(height: 16),
                      _buildSpasialCard(),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // _buildActionIcon(Icons.check),
                          SizedBox(width: 12),
                          // _buildActionIcon(Icons.close),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildUserCard() {
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
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              backgroundImage: user?['foto_profil'] != null
                  ? NetworkImage(user!['foto_profil'])
                  : null,
              child: user?['foto_profil'] == null
                  ? Icon(Icons.person, size: 30, color: Colors.grey[700])
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?['nama'] ?? '-',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Permintaan Konfirmasi ${_labelJenisPermintaan(deskripsi ?? '')} Data',
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user?['nama'] ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            'Permintaan Konfirmasi ${_labelJenisPermintaan(deskripsi ?? '')} Data - ${dataUmum?['nama_lokasi'] ?? '-'}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(CupertinoIcons.doc_fill, size: 20, color: Color(0xFF358666)),
              SizedBox(width: 8),
              Text('Katalog Lokal', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time_filled,
                  size: 20, color: Color(0xFF358666)),
              const SizedBox(width: 8),
              Text(
                  dataUmum?['createdAt'] != null
                      ? DateFormat('dd MMMM yyyy', 'id').format(
                          (dataUmum?['createdAt'] as Timestamp).toDate())
                      : '-',
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIdentifikasiCard() {
    final fotoList = dataUmum?['foto_lokasi'];

    return _buildInfoCard('Identifikasi', {
      'Nama Lokasi': dataUmum?['nama_lokasi'] ?? '-',
      'Kelurahan': dataUmum?['kelurahan'] ?? '-',
      'Kecamatan': dataUmum?['kecamatan'] ?? '-',
      'Kawasan': dataUmum?['kawasan'] ?? '-',
      'Alamat': dataUmum?['alamat'] ?? '-',
      'RT': dataUmum?['rt'] ?? '-',
      'RW': dataUmum?['rw'] ?? '-',
      'Panjang Bentuk': dataUmum?['panjang_bentuk'] ?? '-',
      'Luas Bentuk': dataUmum?['luas_bentuk'] ?? '-',
      'Foto': (fotoList is List && fotoList.isNotEmpty && fotoList[0] is String)
          ? List<String>.from(fotoList.take(3))
          : [],
    });
  }

  Widget _buildSpasialCard() {
    final koordinat = dataSpasial?['titik_koordinat'];

    String formatKoordinat = '-';
    if (koordinat is List && koordinat.length == 2) {
      formatKoordinat =
          '${koordinat[0].toString()}\n${koordinat[1].toString()}';
    } else if (koordinat is String && koordinat.contains(',')) {
      final parts = koordinat.split(',');
      if (parts.length == 2) {
        formatKoordinat = '${parts[0]}\n${parts[1]}';
      }
    }

    return _buildInfoCard('Informasi Spasial', {
      'Titik Koordinat': formatKoordinat,
    });
  }

  Widget _buildInfoCard(String title, Map<String, dynamic> fields) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFD9D9D9), width: 2),
      ),
      color: const Color(0xFFD6F0E1),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500)),
            ),
            const Divider(color: Colors.black),
            ...fields.entries.map((entry) => Column(
                  children: [
                    _buildInfoRow(entry.key, entry.value),
                    const Divider(color: Colors.black),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    if (value is List && value.every((e) => e is String)) {
      return _buildImageRow(label, value.cast<String>());
    }

    if (value is String &&
        (value.endsWith('.jpg') ||
            value.endsWith('.png') ||
            value.endsWith('.jpeg'))) {
      return _buildImageRow(label, [value]); // Bungkus jadi list
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Expanded(
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageRow(String label, List<String> imageList) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label + Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _imageVisibilityMap[label] =
                        !(_imageVisibilityMap[label] ?? false);
                  });
                },
                child: Icon(
                  _imageVisibilityMap[label] == true
                      ? Icons.expand_less
                      : Icons.expand_more,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          // Menampilkan foto
          if (_imageVisibilityMap[label] == true)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList.length.clamp(0, 3),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageList[index],
                          width: 320,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildActionIcon(IconData icon) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       shape: BoxShape.circle,
  //       border: Border.all(color: const Color(0xFF358666), width: 1),
  //     ),
  //     padding: const EdgeInsets.all(10),
  //     child: Icon(icon, color: Colors.black, size: 20),
  //   );
  // }
}
