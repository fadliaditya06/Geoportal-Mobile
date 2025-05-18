import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geoportal_mobile/controllers/ubah_profil_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geoportal_mobile/widget/custom_snackbar.dart';

class UbahProfilScreen extends StatefulWidget {
  const UbahProfilScreen({super.key});

  @override
  State<UbahProfilScreen> createState() => _UbahProfilScreenState();
}

class _UbahProfilScreenState extends State<UbahProfilScreen> {
  final UbahProfilController _controller = UbahProfilController();
  
  // Variabel untuk menyimpan URL gambar yang telah diupload
  String? _uploadedImageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfilePhoto();
  }

  // Fungsi untuk memuat foto profil dari Firestore dan menyimpannya di SharedPreferences
  Future<void> _loadUserProfilePhoto() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Ambil dokumen user dari Firestore
    final doc = await FirebaseFirestore.instance.collection('user').doc(userId).get();
    final photoUrl = doc.data()?['foto_profil'] as String?;

    final prefs = await SharedPreferences.getInstance();

    if (photoUrl != null && photoUrl.isNotEmpty) {
      await prefs.setString(UbahProfilController.prefKeyPhotoUrl, photoUrl);
      setState(() {
        _uploadedImageUrl = photoUrl;
      });
    } else {
      await prefs.remove(UbahProfilController.prefKeyPhotoUrl);
      setState(() {
        _uploadedImageUrl = null;
      });
    }
  }

  // Menampilkan bottom sheet untuk memilih foto
  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Foto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (_uploadedImageUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Hapus Foto'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removePhoto();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk memilih dan mengupload gambar
  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isUploading = true;
    });
    try {
      final url = await _controller.pickAndUploadImage(source);
      if (url != null) {
        setState(() {
          _uploadedImageUrl = url;
        });
      }
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'Gagal upload foto: $e',
        isSuccess: false,
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Fungsi untuk menghapus foto profil
  Future<void> _removePhoto() async {
    if (_uploadedImageUrl == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final success =
            await _controller.deleteProfileImage(_uploadedImageUrl!);
        if (success) {
          await FirebaseFirestore.instance
              .collection('user')
              .doc(userId)
              .update({
            'foto_profil': FieldValue.delete(),
          });

          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(UbahProfilController.prefKeyPhotoUrl);

          setState(() {
            _uploadedImageUrl = null;
          });
          showCustomSnackbar(
            context: context,
            message: 'Foto berhasil dihapus',
            isSuccess: true,
          );
        } else {
          showCustomSnackbar(
            context: context,
            message: 'Gagal menghapus foto',
            isSuccess: false,
          );
        }
      }
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'Gagal menghapus foto: $e',
        isSuccess: false,
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ubah Profil",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          // Gradien Background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.6, 1.0],
            colors: [
              const Color(0xFFB0E1C6),
              const Color(0xFF72B396).withOpacity(0.31),
              const Color(0xFF358666).withOpacity(0.60),
              const Color(0xFFFFFFFF).withOpacity(0.98),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: const Color(0xFF358666),
                      backgroundImage: _uploadedImageUrl != null
                          ? CachedNetworkImageProvider(_uploadedImageUrl!)
                          : null,
                      child: _uploadedImageUrl == null
                          ? const Icon(Icons.person,
                              size: 100, color: Colors.white)
                          : null,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: _showImageSourceSheet,
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xFFB0E1C6),
                            child: Icon(Icons.camera_alt_outlined,
                                size: 24, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isUploading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: CircularProgressIndicator(),
                ),
              const SizedBox(height: 30),
              // Box Container Profil
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle("Email"),
                        _buildTextField(Icons.email_outlined, "Email",
                            isEmail: true),
                        const SizedBox(height: 20),
                        _buildTitle("Nama Lengkap"),
                        _buildTextField(Icons.person_outline, "Nama Lengkap"),
                        const SizedBox(height: 20),
                        _buildTitle("Alamat"),
                        _buildTextField(Icons.home_outlined, "Alamat"),
                        const SizedBox(height: 40),
                        // Tombol Simpan
                        Center(
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF358666),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onPressed: () {
                                showCustomSnackbar(
                                  context: context,
                                  message: 'Data profil berhasil diubah',
                                  isSuccess: true,
                                );
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan judul
  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // Widget untuk menampilkan TextFormField
  Widget _buildTextField(IconData icon, String label, {bool isEmail = false}) {
    return TextFormField(
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        labelText: label,
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        filled: true,
        fillColor: const Color(0xFFB0E1C6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
