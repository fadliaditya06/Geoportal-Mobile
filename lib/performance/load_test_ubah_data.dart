import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geoportal_mobile/controllers/ubah_data_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> runLoadTestUbahData({
  required BuildContext context,
  int totalUsers = 10,
  int rampUpSeconds = 5,
}) async {
  final intervalMs = (rampUpSeconds * 1000) ~/ totalUsers;
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  for (int i = 0; i < totalUsers; i++) {
    Future.delayed(Duration(milliseconds: i * intervalMs), () async {
      try {
        // Buat data spasial dummy
        final docSpasial = await firestore.collection('data_spasial').add({
          'titik_koordinat': '4.5768789123465, 102.43215678945438',
          'status': 'menunggu',
          'created_at': DateTime.now(),
        });

        // Buat data umum dummy yang terhubung ke data spasial
        final docUmum = await firestore.collection('data_umum').add({
          'nama_lokasi': 'Ubah Lokasi Awal $i',
          'kelurahan': 'Kelurahan Awal $i',
          'kecamatan': 'Kecamatan Awal $i',
          'kawasan': 'Kawasan Awal $i',
          'alamat': 'Alamat Awal $i',
          'rt': '002',
          'rw': '004',
          'panjang_bentuk': '2.0010536798',
          'luas_bentuk': '3.00987653e-05',
          'foto_lokasi': [],
          'id_data_spasial': docSpasial.id,
          'created_at': DateTime.now(),
        });
        debugPrint(
          'Data umum dan spasial dummy dibuat: ${docUmum.id}, ${docSpasial.id}',
        );

        // Jeda 10 detik sebelum mengubah data
        await Future.delayed(const Duration(seconds: 10));

        // Inisialisasi controller
        final controller = UbahDataController(
          auth: auth,
          firestore: firestore,
          supabase: Supabase.instance.client,
          storage: Supabase.instance.client.storage.from('images'),
        );

        controller.initWithData({
          'nama_lokasi': ' Lokasi Ubah$i',
          'kelurahan': ' Kelurahan Ubah $i',
          'kecamatan': 'Kecamatan Ubah $i',
          'kawasan': 'Kawasan Ubah $i',
          'alamat': 'Alamat Ubah $i',
          'rt': '002',
          'rw': '004',
          'panjang_bentuk': '2.0010536767',
          'luas_bentuk': '1.00987653e-09',
          'titik_koordinat': '3.5768789123465, 213.43215678945438',
          'foto_lokasi': [],
        });

        // Tambahkan foto dummy
        final byteData = await rootBundle.load('assets/images/test-mock.jpg');
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/ubah_sample_$i.jpg');
        await file.writeAsBytes(byteData.buffer.asUint8List());

        controller.fotoFiles.add(file);

        // Simpan perubahan
        await controller.simpanPerubahan(
          docUmum.id,
          docSpasial.id,
          context,
          isLoadTest: true,
        );
      } catch (e) {
        debugPrint('Gagal ubah data ke-$i: $e');
      }
    });
  }
}
