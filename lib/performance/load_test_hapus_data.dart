import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geoportal_mobile/services/firebase_performance_tracer.dart';

Future<void> runLoadTestHapusData({
  int totalUsers = 10,
  int rampUpSeconds = 5,
}) async {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final intervalMs = (rampUpSeconds * 1000) ~/ totalUsers;

  for (int i = 0; i < totalUsers; i++) {
    Future.delayed(Duration(milliseconds: i * intervalMs), () async {
      final tracer = FirebasePerformanceTracer('trace_hapus_data');
      final stopwatch = Stopwatch()..start();

      await tracer.start();

      try {
        // Tambahkan data dummy untuk dihapus
        final docSpasial = await firestore.collection('data_spasial').add({
          'titik_koordinat': '3.5768789123465, 213.43215678945438',
          'status': 'menunggu',
          'created_at': DateTime.now(),
        });

        final docUmum = await firestore.collection('data_umum').add({
          'nama_lokasi': 'Lokasi Hapus $i',
          'kelurahan': 'Kelurahan Hapus $i',
          'kecamatan': 'Kecamatan Hapus $i',
          'kawasan': 'Kawasan Hapus $i',
          'alamat': 'Alamat Hapus $i',
          'rt': '005',
          'rw': '006',
          'panjang_bentuk': '2.0010536767',
          'luas_bentuk': '1.00987653e-09',
          'foto_lokasi': [],
          'id_data_spasial': docSpasial.id,
          'created_at': DateTime.now(),
        });
        debugPrint(
          'Data umum dan spasial dummy dibuat: ${docUmum.id}, ${docSpasial.id}',
        );

        // Jeda 10 detik sebelum menghapus data
        await Future.delayed(const Duration(seconds: 10));

        // Hapus data umum dan spasial
        await firestore.collection('data_umum').doc(docUmum.id).delete();
        await firestore.collection('data_spasial').doc(docSpasial.id).delete();

        stopwatch.stop();
        final userId = auth.currentUser?.uid ?? 'unknown_user';
        print(
          'User $userId waktu hapusData ke-$i: ${stopwatch.elapsedMilliseconds} ms',
        );

        await tracer.stop();
      } catch (e) {
        stopwatch.stop();
        print('Gagal hapus data ke-$i: $e');
        await tracer.stop();
      }
    });
  }
}
