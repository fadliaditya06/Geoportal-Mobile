import 'package:cloud_firestore/cloud_firestore.dart';

class LogKonfirmasiModel {
  final String uid;
  final String nama;
  final String peran;
  final String deskripsi;
  final String status;
  final Timestamp timestamp;
  final Map<String, dynamic> data;
  final Map<String, dynamic>? dataBaru;

  LogKonfirmasiModel({
    required this.uid,
    required this.nama,
    required this.peran,
    required this.deskripsi,
    required this.status,
    required this.timestamp,
    required this.data,
    this.dataBaru,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'peran': peran,
      'deskripsi': deskripsi,
      'status': status,
      'timestamp': timestamp,
      'data': data,
      if (dataBaru != null) 'data_baru': dataBaru,
    };
  }

  factory LogKonfirmasiModel.fromMap(Map<String, dynamic> map) {
    return LogKonfirmasiModel(
      uid: map['uid'] ?? '',
      nama: map['nama'] ?? '',
      peran: map['peran'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      status: map['status'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      dataBaru: map['data_baru'] != null
          ? Map<String, dynamic>.from(map['data_baru'])
          : null,
    );
  }
}
