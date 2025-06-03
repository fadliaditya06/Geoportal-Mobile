import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String nama;
  final String alamat;
  final String peran;
  final String fotoProfil;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.nama,
    required this.alamat,
    required this.peran,
    required this.fotoProfil,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nama': nama,
      'alamat': alamat,
      'peran': peran,
      'foto_profil': fotoProfil,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      nama: map['nama'],
      alamat: map['alamat'],
      peran: map['peran'],
      fotoProfil: map['foto_profil'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
