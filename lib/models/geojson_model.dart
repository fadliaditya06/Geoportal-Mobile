class GeoJSONDataModel {
  final String kelurahan;
  final String kecamatan;
  final String kawasan;
  final String lokasi;
  final String alamat;
  final String rt;
  final String rw;
  final String shapeLength;
  final String shapeArea;
  final String coordinates;

  GeoJSONDataModel({
    required this.kelurahan,
    required this.kecamatan,
    required this.kawasan,
    required this.lokasi,
    required this.alamat,
    required this.rt,
    required this.rw,
    required this.shapeLength,
    required this.shapeArea,
    required this.coordinates,
  });

  factory GeoJSONDataModel.fromMap(Map<String, dynamic> map) {
    return GeoJSONDataModel(
      kelurahan: map['kelurahan'] ?? '',
      kecamatan: map['kecamatan'] ?? '',
      kawasan: map['kawasan'] ?? '',
      lokasi: map['lokasi'] ?? '',
      alamat: map['alamat'] ?? '',
      rt: map['rt']?.toString() ?? '',
      rw: map['rw']?.toString() ?? '',
      shapeLength: map['shape_length']?.toString() ?? '',
      shapeArea: map['shape_area']?.toString() ?? '',
      coordinates: map['coordinates'] ?? '',
    );
  }
}
