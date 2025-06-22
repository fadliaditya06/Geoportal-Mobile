import 'package:cloud_firestore/cloud_firestore.dart';

class DataUmumModel {
  final String id;
  final String namaLokasi;
  final String kelurahan;
  final String kecamatan;
  final String kawasan;
  final String alamat;
  final String rt;
  final String rw;
  final String panjangBentuk;
  final String luasBentuk;
  final List<String> fotoLokasi;
  final String idDataSpasial;
  final DateTime createdAt;

  DataUmumModel({
    required this.id,
    required this.namaLokasi,
    required this.kelurahan,
    required this.kecamatan,
    required this.kawasan,
    required this.alamat,
    required this.rt,
    required this.rw,
    required this.panjangBentuk,
    required this.luasBentuk,
    required this.fotoLokasi,
    required this.idDataSpasial,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_data_umum': id,
      'nama_lokasi': namaLokasi,
      'kelurahan': kelurahan,
      'kecamatan': kecamatan,
      'kawasan': kawasan,
      'alamat': alamat,
      'rt': rt,
      'rw': rw,
      'panjang_bentuk': panjangBentuk,
      'luas_bentuk': luasBentuk,
      'foto_lokasi': fotoLokasi,
      'id_data_spasial': idDataSpasial,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
