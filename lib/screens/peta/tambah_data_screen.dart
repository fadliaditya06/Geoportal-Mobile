import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geoportal_mobile/screens/peta/detail_peta_screen.dart';
import 'package:geoportal_mobile/controllers/tambah_data_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class TambahDataScreen extends StatefulWidget {
  const TambahDataScreen({super.key});

  @override
  State<TambahDataScreen> createState() => _TambahDataScreenState();
}

class _TambahDataScreenState extends State<TambahDataScreen> {
  late final TambahDataController controller;

  @override
  void initState() {
    super.initState();
    controller = TambahDataController(
      lokasiController: TextEditingController(),
      kelurahanController: TextEditingController(),
      kecamatanController: TextEditingController(),
      kawasanController: TextEditingController(),
      alamatController: TextEditingController(),
      rtController: TextEditingController(),
      rwController: TextEditingController(),
      panjangBentukController: TextEditingController(),
      luasBentukController: TextEditingController(),
      formKey: GlobalKey<FormState>(),
      titikKoordinatController: TextEditingController(),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 36),
          onPressed: () => Navigator.pop(context),
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
          // Form Tambah Data
          child: Form(
            key: controller.formKey,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Data Umum'),
                  _buildTitle("Nama Kelurahan"),
                  _buildTextField(
                    controller: controller.kelurahanController,
                    label: 'Contoh: Kelurahan Duriangkang',
                    validator: (value) => value!.isEmpty
                        ? 'Silahkan masukkan nama kelurahan'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  _buildTitle("Nama Kecamatan"),
                  _buildTextField(
                    controller: controller.kecamatanController,
                    label: 'Contoh: Kecamatan Sei Beduk',
                    validator: (value) => value!.isEmpty
                        ? 'Silahkan masukkan nama kecamatan'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  // _buildTitle("Publikasi"),
                  // _buildTextField(
                  //   label: 'Publikasi',
                  //   controller: controller.publikasiController,
                  //   readOnly: true,
                  //   onTap: () => controller.selectDate(context),
                  //   validator: (value) => value!.isEmpty
                  //       ? 'Silahkan masukkan tanggal publikasi'
                  //       : null,
                  //   suffixIcon: Icons.calendar_today,
                  // ),
                  // const SizedBox(height: 10),
                  _buildTitle("Kawasan"),
                  DropdownButtonFormField<String>(
                    value: controller.kawasanController.text.isNotEmpty
                        ? controller.kawasanController.text
                        : null,
                    items: const [
                      DropdownMenuItem(
                        value: 'Kawasan Pengembang',
                        child: Text(
                          'Kawasan Pengembang',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Kawasan Non Pengembang',
                        child: Text(
                          'Kawasan Non Pengembang',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.kawasanController.text = value;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Jenis Kawasan',
                      labelStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFB0E1C6),
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFB0E1C6),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFB0E1C6),
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Silahkan pilih jenis kawasan'
                        : null,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTitle("Nama Lokasi"),
                  _buildTextField(
                    controller: controller.lokasiController,
                    label: 'Contoh: Perumahan Mutiara Hijau ',
                    validator: (value) =>
                        value!.isEmpty ? 'Silahkan masukkan nama lokasi' : null,
                  ),
                  const SizedBox(height: 10),
                  _buildTitle("Alamat"),
                  _buildTextField(
                    controller: controller.alamatController,
                    label: 'Contoh: Blok C2 No 15',
                    validator: (value) =>
                        value!.isEmpty ? 'Silahkan masukkan alamat' : null,
                  ),
                  const SizedBox(height: 10),
                  _buildTitle("RT"),
                  _buildTextField(
                    controller: controller.rtController,
                    label: 'Contoh: 003',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silahkan masukkan nomor RT';
                      }
                      if (!RegExp(r'^\d{1,3}$').hasMatch(value)) {
                        return 'Nomor RT maksimal 3 digit angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTitle("RW"),
                  _buildTextField(
                    controller: controller.rwController,
                    label: 'Contoh: 006',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silahkan masukkan nomor RW';
                      }
                      if (!RegExp(r'^\d{1,3}$').hasMatch(value)) {
                        return 'Nomor RW maksimal 3 digit angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTitle("Panjang Bentuk"),
                  _buildTextField(
                    controller: controller.panjangBentukController,
                    label: 'Contoh: 0.00079236174892200004',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9eE\.\-]*$')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silahkan masukkan panjang bentuk';
                      }

                      final parsed = double.tryParse(value);
                      if (parsed == null) {
                        return 'Masukkan angka desimal yang valid';
                      }

                      if (parsed <= 0) {
                        return 'Panjang harus lebih dari 0';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildTitle("Luas Bentuk"),
                  _buildTextField(
                    controller: controller.luasBentukController,
                    label: 'Contoh: 1.14035827148e-08',
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9eE\.\-]*$')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silahkan masukkan luas bentuk';
                      }

                      final parsed = double.tryParse(value);
                      if (parsed == null) {
                        return 'Masukkan angka desimal yang valid';
                      }

                      if (parsed <= 0) {
                        return 'Luas harus lebih dari 0';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildTitle("Foto"),
                  FormField<List<File>>(
                    validator: (files) {
                      if (controller.fotoFiles.isEmpty) {
                        return 'Silahkan masukkan maksimal 3 foto';
                      } else if (controller.fotoFiles.length > 3) {
                        return 'Silahkan masukkan maksimal 3 foto';
                      }
                      return null;
                    },
                    builder: (FormFieldState<List<File>> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await controller.pilihFoto(context);
                              state.didChange(controller.fotoFiles);
                              setState(() {});
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
                                    Text(
                                      'Tambah Foto',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Untuk mock foto ketika pengujian
                          if (const bool.fromEnvironment('TEST_MODE')) ...[
                            ElevatedButton(
                              key: const Key('btnMockFoto'),
                              onPressed: () async {
                                final byteData = await rootBundle
                                    .load('assets/images/test-mock.jpg');
                                final tempDir = await getTemporaryDirectory();
                                final file =
                                    File('${tempDir.path}/test-mock.jpg');
                                await file.writeAsBytes(
                                    byteData.buffer.asUint8List());

                                controller.fotoFiles.add(file);
                                state.didChange(controller.fotoFiles);
                                setState(() {});
                              },
                              child: const Text('USE_TEST_IMAGE'),
                            ),
                          ],
                          const SizedBox(height: 10),
                          // Preview foto
                          if (controller.fotoFiles.isNotEmpty)
                            Column(
                              children: controller.fotoFiles
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                File file = entry.value;
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      width: 360,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: FileImage(file),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.hapusFoto(index);
                                          state.didChange(controller.fotoFiles);
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          // Error message dari validator
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                state.errorText!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 40),
                        ],
                      );
                    },
                  ),
                  _buildSectionTitle('Data Spasial'),
                  _buildTitle("Titik Koordinat"),
                  _buildTextField(
                    key: const Key('fieldKoordinat'),
                    label: 'Titik Koordinat',
                    controller: controller.titikKoordinatController,
                    readOnly: true,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Silahkan masukkan titik koordinat'
                        : null,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DetailPetaScreen(
                              isKonfirmasiKoordinat: false),
                        ),
                      );
                      if (result != null && result is String) {
                        setState(() {
                          controller.titikKoordinatController.text = result;
                        });
                      }
                    },
                    suffixIcon: Icons.map,
                    onSuffixTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DetailPetaScreen(),
                        ),
                      );
                      if (result != null && result is String) {
                        setState(() {
                          controller.titikKoordinatController.text = result;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF92E3A9),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: controller.isLoading
                            ? null
                            : () async {
                                setState(() {
                                  controller.isLoading = true;
                                });
                                await controller.simpanData(context);
                                setState(() {
                                  controller.isLoading = false;
                                });
                              },
                        child: controller.isLoading
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan judul
  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan judul
  Widget _buildSectionTitle(String title) {
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

  // Fungsi untuk membangun TextField dengan label
  Widget _buildTextField({
    Key? key,
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
        filled: true,
        fillColor: const Color(0xFFB0E1C6),
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Color(0xFFB0E1C6), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Color(0xFFB0E1C6), width: 1),
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, color: Colors.black, size: 22),
                onPressed: onSuffixTap,
              )
            : null,
      ),
      onTap: onTap,
      validator: validator,
    );
  }
}
