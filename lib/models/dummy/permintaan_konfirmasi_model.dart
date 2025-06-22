class PermintaanKonfirmasiModel {
  final String id;
  final String name; 
  final String status; 
  final String lokasi; 
  final String jenisPermintaan; 
  final DateTime tanggalPermintaan;

  PermintaanKonfirmasiModel({
    required this.id,
    required this.name,
    required this.status,
    required this.lokasi,
    required this.jenisPermintaan,
    required this.tanggalPermintaan,
  });

  static List<PermintaanKonfirmasiModel> dummyDataKonfirmasi = [
    PermintaanKonfirmasiModel(
      id: '1',
      name: 'Hana Annisa',
      status: 'Permintaan Disetujui',
      lokasi: 'One Mall Batam',
      jenisPermintaan: 'Katalog Lokal',
      tanggalPermintaan: DateTime(2024, 4, 10),
    ),
    PermintaanKonfirmasiModel(
      id: '2',
      name: 'Hana Annisa',
      status: 'Permintaan Disetujui',
      lokasi: 'One Mall Batam',
      jenisPermintaan: 'Katalog Lokal',
      tanggalPermintaan: DateTime(2024, 4, 15),
    ),
    PermintaanKonfirmasiModel(
      id: '3',
      name: 'Hana Annisa',
      status: 'Permintaan Disetujui',
      lokasi: 'One Mall Batam',
      jenisPermintaan: 'Katalog Lokal',
      tanggalPermintaan: DateTime(2024, 4, 9),
    ),
    PermintaanKonfirmasiModel(
      id: '4',
      name: 'Hana Annisa',
      status: 'Permintaan konfirmasi anda ditolak karena beberapa alasan',
      lokasi: 'One Mall Batam',
      jenisPermintaan: 'Katalog Lokal',
      tanggalPermintaan: DateTime(2024, 4, 23),
    ),
    PermintaanKonfirmasiModel(
      id: '5',
      name: 'Hana Annisa',
      status: 'Permintaan konfirmasi anda ditolak karena beberapa alasan',
      lokasi: 'One Mall Batam',
      jenisPermintaan: 'Katalog Lokal',
      tanggalPermintaan: DateTime(2024, 4, 25),
    ),
    PermintaanKonfirmasiModel(
      id: '6',
      name: 'Hana Annisa',
      status: 'Permintaan konfirmasi anda ditolak karena beberapa alasan',
      lokasi: 'One Mall Batam',
      jenisPermintaan: 'Katalog Lokal',
      tanggalPermintaan: DateTime(2024, 4, 27),
    ),
  ];
}
