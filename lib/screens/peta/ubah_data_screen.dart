import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geoportal_mobile/controllers/ubah_data_controller.dart';
import 'package:geoportal_mobile/screens/peta/detail_peta_screen.dart';
import 'package:path_provider/path_provider.dart';

class UbahDataScreen extends StatefulWidget {
  final String idDataUmum;
  final String idDataSpasial;
  final Map<String, dynamic> data;

  const UbahDataScreen({
    super.key,
    required this.idDataUmum,
    required this.idDataSpasial,
    required this.data,
  });

  @override
  State<UbahDataScreen> createState() => _UbahDataScreenState();
}

class _UbahDataScreenState extends State<UbahDataScreen> {
  late final UbahDataController controller;

  @override
  void initState() {
    super.initState();
    controller = UbahDataController();
    controller.initWithData(widget.data);
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
          'Ubah Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 21, 16, 8),
        // Form Ubah Data
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
                _buildTitle("Kawasan"),
                _buildDropdownField(),
                const SizedBox(height: 10),
                _buildTitle("Nama Lokasi"),
                _buildTextField(
                  key: const Key('fieldNamaLokasi'),
                  controller: controller.lokasiController,
                  label: 'Contoh: Perumahan Mutiara Hijau',
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
                  key: const Key('fieldRT'),
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
                  key: const Key('fieldRW'),
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
                _buildDecimalField(controller.panjangBentukController,
                    'Contoh: 0.00079236174892200004'),
                const SizedBox(height: 10),
                _buildTitle("Luas Bentuk"),
                _buildDecimalField(controller.luasBentukController,
                    'Contoh: 1.14035827148e-08'),
                const SizedBox(height: 10),
                _buildTitle("Foto"),
                _buildFotoField(),
                _buildSectionTitle('Data Spasial'),
                _buildTitle("Titik Koordinat"),
                _buildKoordinatField(),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: Obx(() => ElevatedButton(
                          key: const Key('btnSimpanUbahData'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF92E3A9),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  if (controller.formKey.currentState
                                          ?.validate() ??
                                      false) {
                                    await controller.simpanPerubahan(
                                      widget.idDataUmum,
                                      widget.idDataSpasial,
                                      context,
                                    );
                                  } else {}
                                },
                          child: controller.isLoading.value
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
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    Key? key,
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: const Color(0xFFB0E1C6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFB0E1C6)),
        ),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: Colors.black))
            : null,
      ),
    );
  }

  Widget _buildDecimalField(TextEditingController controller, String label) {
    return _buildTextField(
      controller: controller,
      label: label,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9eE.\-]*$'))
      ],
      validator: (value) {
        if (value == null || value.isEmpty) return 'Silahkan masukkan $label';
        final parsed = double.tryParse(value);
        if (parsed == null || parsed <= 0) {
          return 'Masukkan nilai $label yang valid';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
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
      onChanged: (value) => controller.kawasanController.text = value!,
      decoration: InputDecoration(
        labelText: 'Jenis Kawasan',
        labelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Colors.black,
        ),
        filled: true,
        fillColor: const Color(0xFFB0E1C6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFB0E1C6)),
        ),
      ),
      validator: (value) => value == null || value.isEmpty
          ? 'Silahkan pilih jenis kawasan'
          : null,
    );
  }

  Widget _buildFotoField() {
    return FormField<List<File>>(
      validator: (files) {
        int totalFoto =
            controller.fotoUrls.length + controller.fotoFiles.length;
        if (totalFoto == 0) return 'Silahkan masukkan minimal 1 foto';
        if (totalFoto > 3) return 'Maksimal 3 foto yang diperbolehkan';
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await controller.pilihFoto(context);
                state.didChange(controller.fotoFiles);
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
                      Text('Ubah Foto', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Tambahkan di dalam _buildFotoField atau sejenisnya
            if (const bool.fromEnvironment('TEST_MODE')) ...[
              ElevatedButton(
                key: const Key('btnMockUbahFoto'),
                onPressed: () async {
                  try {
                    final byteData =
                        await rootBundle.load('assets/images/test-mock-2.jpg');

                    final tempDir = await getTemporaryDirectory();
                    final file = File('${tempDir.path}/test-mock-2.jpg');
                    await file.writeAsBytes(byteData.buffer.asUint8List());

                    controller.fotoFiles.clear();
                    controller.fotoFiles.add(file);
                    state.didChange(controller.fotoFiles);
                    setState(() {});
                  } catch (e) {
                    debugPrint('Gagal memuat gambar mock: $e');
                  }
                },
                child: const Text('USE_TEST_IMAGE'),
              ),
            ],
            const SizedBox(height: 10),
            ...controller.fotoUrls.asMap().entries.map((entry) {
              int index = entry.key;
              String url = entry.value;
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    width: 360,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(url), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        controller.fotoUrls.removeAt(index);
                        state.didChange(controller.fotoFiles);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: Icon(Icons.close, size: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              );
            }),
            ...controller.fotoFiles.asMap().entries.map((entry) {
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
                          image: FileImage(file), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        controller.fotoFiles.removeAt(index);
                        state.didChange(controller.fotoFiles);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: Icon(Icons.close, size: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              );
            }),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 4),
                child: Text(state.errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  Widget _buildKoordinatField() {
    return _buildTextField(
      controller: controller.titikKoordinatController,
      label: 'Titik Koordinat',
      readOnly: true,
      key: const Key('btnUbahKoordinat'),
      validator: (value) => value == null || value.isEmpty
          ? 'Silahkan masukkan Titik Koordinat'
          : null,
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const DetailPetaScreen(isKonfirmasiKoordinat: false),
          ),
        );
        if (result != null && result is String) {
          controller.titikKoordinatController.text = result;
        }
      },
      suffixIcon: Icons.map,
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const Divider(color: Colors.black),
        const SizedBox(height: 8),
      ],
    );
  }
}
