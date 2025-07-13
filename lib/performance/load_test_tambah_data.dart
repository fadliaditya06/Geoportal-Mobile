import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:geoportal_mobile/controllers/tambah_data_controller.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> runLoadTestTambahData({
  required BuildContext context,
  int totalUsers = 10,
  int rampUpSeconds = 5,
}) async {
  final intervalMs = (rampUpSeconds * 1000) ~/ totalUsers;

  for (int i = 0; i < totalUsers; i++) {
    Future.delayed(Duration(milliseconds: i * intervalMs), () async {
      final controller = TambahDataController(
        lokasiController: TextEditingController(text: 'Lokasi $i'),
        kelurahanController: TextEditingController(text: 'Kelurahan $i'),
        kecamatanController: TextEditingController(text: 'Kecamatan $i'),
        kawasanController: TextEditingController(text: 'Kawasan $i'),
        alamatController: TextEditingController(text: 'Alamat $i'),
        rtController: TextEditingController(text: '001'),
        rwController: TextEditingController(text: '003'),
        panjangBentukController: TextEditingController(text: '0.0010536798'),
        luasBentukController: TextEditingController(text: '2.00987653e-07'),
        titikKoordinatController:
            TextEditingController(text: '1.5768789123465, 308.43215678945438'),
        formKey: GlobalKey<FormState>(),
      );

      // Tambah upload foto dummy
      final byteData = await rootBundle.load('assets/images/rumah.jpeg');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/sample_$i.jpg');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      controller.fotoFiles.add(file);

      await controller.simpanData(context, isLoadTest: true);
    });
  }
}
