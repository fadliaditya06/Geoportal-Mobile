import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class UnduhDataController extends ChangeNotifier {
  String? savedFilePath;
  List<String> lokasiList = [];
  String? selectedLokasi;
  Map<String, dynamic>? selectedDataUmum;
  Map<String, dynamic>? selectedDataSpasial;
  bool loadingLokasi = true;
  bool loadingPdf = false;
  String? errorMessage;

  UnduhDataController() {
    fetchNamaLokasi();
  }

  void setLoading(bool value) {
    loadingPdf = value;
    notifyListeners();
  }

  Future<void> fetchNamaLokasi() async {
    loadingLokasi = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('data_umum').get();

      final list = snapshot.docs
          .map((doc) => doc.data()['nama_lokasi']?.toString())
          .whereType<String>()
          .toList();

      lokasiList = list;
      loadingLokasi = false;
      notifyListeners();
    } catch (e) {
      loadingLokasi = false;
      errorMessage = 'Gagal memuat data lokasi: $e';
      notifyListeners();
    }
  }

  Future<pw.MemoryImage?> _downloadImage(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200
          ? pw.MemoryImage(response.bodyBytes)
          : null;
    } catch (e) {
      debugPrint('Error download image: $e');
      return null;
    }
  }

  Future<void> fetchDataByNamaLokasi(String namaLokasi) async {
    loadingPdf = true;
    notifyListeners();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('data_umum')
          .where('nama_lokasi', isEqualTo: namaLokasi)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        errorMessage = 'Data dengan lokasi tersebut tidak ditemukan';
        selectedDataUmum = null;
        selectedDataSpasial = null;
        loadingPdf = false;
        notifyListeners();
        return;
      }

      final dataUmum = querySnapshot.docs.first.data();
      selectedDataUmum = dataUmum;

      final idSpasial = dataUmum['id_data_spasial'];
      if (idSpasial != null) {
        final spasialDoc = await FirebaseFirestore.instance
            .collection('data_spasial')
            .doc(idSpasial)
            .get();
        selectedDataSpasial = spasialDoc.exists ? spasialDoc.data() : null;
      } else {
        selectedDataSpasial = null;
      }

      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error mengambil data: $e';
      selectedDataUmum = null;
      selectedDataSpasial = null;
    }

    loadingPdf = false;
    notifyListeners();
  }

  Future<pw.Document> generatePdf(
      Map<String, dynamic> dataUmum, Map<String, dynamic>? dataSpasial) async {
    final pdf = pw.Document();

    // Ambil list URL dari array foto_lokasi
    final List fotoUrls = dataUmum['foto_lokasi'] ?? [];
    final List<pw.MemoryImage> images = [];

    for (var url in fotoUrls) {
      final image = await _downloadImage(url.toString());
      if (image != null) {
        images.add(image);
      }
    }

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'Data Umum',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Text('Nama Lokasi: ${dataUmum["nama_lokasi"] ?? "-"}'),
            pw.SizedBox(height: 4),
            pw.Text('Kelurahan: ${dataUmum["kelurahan"] ?? "-"}'),
            pw.SizedBox(height: 4),
            pw.Text('Kecamatan: ${dataUmum["kecamatan"] ?? "-"}'),
            pw.SizedBox(height: 4),
            pw.Text('Alamat: ${dataUmum["alamat"] ?? "-"}'),
            pw.SizedBox(height: 4),
            // pw.Text('Publikasi: ${dataUmum["publikasi"] ?? "-"}'),
            // pw.SizedBox(height: 4),
            pw.Text('RT: ${dataUmum["rt"] ?? "-"}'),
            pw.SizedBox(height: 4),
            pw.Text('RW: ${dataUmum["rw"] ?? "-"}'),
            pw.SizedBox(height: 4),
            pw.Text('Panjang Bentuk: ${dataUmum["panjang_bentuk"] ?? "-"}'),
            pw.SizedBox(height: 4),
            pw.Text('Luas Bentuk: ${dataUmum["luas_bentuk"] ?? "-"}'),
            pw.SizedBox(height: 4),
            pw.Text('Foto Lokasi:'),
            pw.SizedBox(height: 8),
            if (images.isNotEmpty)
              pw.Wrap(
                spacing: 10,
                runSpacing: 10,
                children: images
                    .map((img) => pw.Image(img,
                        width: 180, height: 130, fit: pw.BoxFit.cover))
                    .toList(),
              )
            else
              pw.Text('Foto tidak tersedia atau gagal dimuat'),
            pw.SizedBox(height: 30),
            if (dataSpasial != null) ...[
              pw.Center(
                child: pw.Text(
                  'Data Spasial',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Text(
                  'Titik Koordinat: ${dataSpasial["titik_koordinat"] ?? "-"}'),
              pw.SizedBox(height: 12),
            ] else
              pw.Text('Data spasial tidak tersedia'),
          ],
        ),
      ),
    );

    return pdf;
  }

  Future<String?> savePdfToStorage(pw.Document pdf) async {
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        errorMessage = 'Gagal mendapatkan direktori penyimpanan';
        notifyListeners();
        return null;
      }

      final safeFileName =
          'data_${selectedLokasi?.replaceAll(' ', '_').toLowerCase() ?? 'file'}.pdf';
      final file = File('${dir.path}/$safeFileName');
      await file.writeAsBytes(await pdf.save());

      return file.path;
    } catch (e) {
      errorMessage = 'Gagal menyimpan PDF: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> downloadAndGeneratePDF() async {
    if (selectedLokasi == null) {
      errorMessage = 'Silakan pilih lokasi terlebih dahulu';
      notifyListeners();
      return;
    }

    loadingPdf = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('data_umum')
          .where('nama_lokasi', isEqualTo: selectedLokasi)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        errorMessage = 'Data tidak ditemukan';
        loadingPdf = false;
        notifyListeners();
        return;
      }

      final dataUmum = snapshot.docs.first.data();
      Map<String, dynamic>? dataSpasial;
      final id = dataUmum['id_data_spasial'];
      if (id != null) {
        final spasialDoc = await FirebaseFirestore.instance
            .collection('data_spasial')
            .doc(id)
            .get();
        dataSpasial = spasialDoc.exists ? spasialDoc.data() : null;
      }

      final pdf = await generatePdf(dataUmum, dataSpasial);
      final path = await savePdfToStorage(pdf);

      savedFilePath = path;
      errorMessage = null;

      if (path != null) {
        await Share.shareXFiles(
          [XFile(path)],
          text: 'Berikut file PDF data lokasi: $selectedLokasi',
        );
      }
    } catch (e) {
      errorMessage = 'Gagal membuat PDF: $e';
    }

    loadingPdf = false;
    notifyListeners();
  }
}
