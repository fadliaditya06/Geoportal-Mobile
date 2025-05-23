import 'package:flutter/material.dart';
import 'package:geoportal_mobile/screens/peta/detail_peta_screen.dart';
import 'package:intl/intl.dart';

class TambahDataScreen extends StatefulWidget {
  const TambahDataScreen({super.key});

  @override
  State<TambahDataScreen> createState() => _TambahDataScreenState();
}

class _TambahDataScreenState extends State<TambahDataScreen> {
  final TextEditingController publikasiController = TextEditingController();
  final TextEditingController titikKoordinatController = TextEditingController();

  // Fungsi untuk memilih tanggal menggunakan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('id'),
    );

    if (pickedDate != null) {
      setState(() {
        publikasiController.text = DateFormat('dd MMMM yyyy', 'id').format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    publikasiController.dispose();
    titikKoordinatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: IconButton(
            iconSize: 36,
            icon: const Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
        ),
        title: const Text(
          'Tambah Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.36, 0.76, 1.0],
            colors: [
              Color(0xFFB0E1C6),
              Color(0xFFFFFFFF),
              Color(0xFF72B396),
              Color(0xFF358666),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 21, 16, 8),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle('Data Umum'),
                buildLabel('Judul'),
                TextFormField(decoration: buildInputDecoration('Judul')),
                const SizedBox(height: 10),
                buildLabel('Pemilik'),
                TextFormField(decoration: buildInputDecoration('Pemilik')),
                const SizedBox(height: 10),
                buildLabel('Publikasi'),
                TextFormField(
                  controller: publikasiController,
                  readOnly: true,
                  decoration: buildInputDecoration('Publikasi'),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 10),
                buildLabel('Jenis Sumber Daya'),
                TextFormField(decoration: buildInputDecoration('Jenis Sumber Daya')),
                const SizedBox(height: 10),
                buildLabel('Sumber'),
                TextFormField(decoration: buildInputDecoration('Sumber')),
                const SizedBox(height: 10),
                buildLabel('Foto'),
                GestureDetector(
                  onTap: () {
                    //
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0E1C6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload),
                          SizedBox(width: 8),
                          Text('Tambah Foto', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                buildSectionTitle('Data Spasial'),
                buildLabel('Sistem Proyek'),
                TextFormField(decoration: buildInputDecoration('Sistem Proyek')),
                const SizedBox(height: 10),
                buildLabel('Titik Koordinat'),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      controller: titikKoordinatController,
                      readOnly: true,
                      decoration: buildInputDecoration('Titik Koordinat').copyWith(
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.map,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DetailPetaScreen(),
                              ),
                            );
                            if (result != null && result is String) {
                              setState(() {
                                titikKoordinatController.text = result;
                              });
                            }
                          },
                        ),
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DetailPetaScreen(
                              isKonfirmasiKoordinat: false,
                            ),
                          ),
                        );
                        if (result != null && result is String) {
                          setState(() {
                            titikKoordinatController.text = result;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Tombol Simpan
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      //
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF92E3A9),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      elevation: 10,
                      shadowColor: const Color.fromARGB(255, 133, 129, 129),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat input decoration untuk form field
  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFB0E1C6),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Color(0xFFB0E1C6), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Color(0xFFB0E1C6), width: 1),
      ),
    );
  }

  // Fungsi untuk menampilkan label
  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  // Fungsi untuk menampilkan judul
  Widget buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const Divider(color: Colors.black),
        const SizedBox(height: 8),
      ],
    );
  }
}
