import 'package:cloud_firestore/cloud_firestore.dart';

class DataSpasialModel {
  final String titikKoordinat;
  final String status;
  final DateTime createdAt;

  DataSpasialModel({
    required this.titikKoordinat,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'titik_koordinat': titikKoordinat,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
