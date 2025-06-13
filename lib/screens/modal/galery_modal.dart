import 'package:flutter/material.dart';

class GaleriModal {
  static void showGaleriModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB0E1C6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tombol Tutup
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      shape: const CircleBorder(),
                      elevation: 4,
                      color: Colors.white,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child:
                              Icon(Icons.close, color: Colors.black, size: 20),
                        ),
                      ),
                    ),
                  ),
                ),

                // Judul untuk Modal
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Text(
                      'Semua Galery Kami',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // Konten Galeri
                SizedBox(
                  height: 340,
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _semuaGalery(
                            image:
                                'assets/images/galeri/galeri-${index + 1}.png',
                            title: index == 0
                                ? 'Sekupang'
                                : index == 1
                                    ? 'Sei Beduk'
                                    : index == 2
                                        ? 'Nongsa'
                                        : 'Batu Aji',
                            description: index == 0
                                ? 'Luas Kecamatan Sekupang, Kota Batam adalah 106,78 kilometer persegi (km²).'
                                : index == 1
                                    ? 'Luas Kecamatan Sei Beduk, Kota Batam adalah 101,63 kilometer persegi (km²).'
                                    : index == 2
                                        ? 'Luas Kecamatan Nongsa, Kota Batam adalah 145,32 kilometer persegi (km²).'
                                        : 'Luas Kecamatan Batu Aji, Kota Batam adalah 20,13 kilometer persegi (km²).',
                          ),
                          if (index != 3) const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget untuk menampilkan konten galeri dengan gambar, judul, dan deskripsi
  static Widget _semuaGalery({
    required String image,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFB0E1C6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD8D8D8), width: 3),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 100,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF358666),
                  ),
                ),
                const Divider(
                  color: Color(0xFF358666),
                  thickness: 1,
                  height: 8,
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
