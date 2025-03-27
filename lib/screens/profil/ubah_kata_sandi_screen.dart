import 'package:flutter/material.dart';

class UbahKataSandiScreen extends StatefulWidget {
  const UbahKataSandiScreen({super.key});

  @override
  UbahKataSandiScreenState createState() => UbahKataSandiScreenState();
}

class UbahKataSandiScreenState extends State<UbahKataSandiScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Ubah Kata Sandi",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          textAlign: TextAlign.left,
        ),
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
      ),
      // Konten Ubah Kata Sandi
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Image.asset(
                  'assets/images/ubah-kata-sandi.png',
                  width: 200,
                ),
              ),
              // Form Ubah Kata Sandi
              const SizedBox(height: 30),
              ListView(
                shrinkWrap: true,
                children: [
                  _buildTitle("Kata Sandi Lama"),
                  _buildTextField("Kata Sandi Lama"),
                  const SizedBox(height: 20),
                  _buildTitle("Kata Sandi Baru"),
                  _buildTextField("Kata Sandi Baru"),
                  const SizedBox(height: 20),
                  _buildTitle("Konfirmasi Kata Sandi"),
                  _buildTextField("Konfirmasi Kata Sandi"),
                  const SizedBox(height: 30),
                ],
              ),
              // Tombol Simpan
              Center(
                child: SizedBox(
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF358666),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  // Widget untuk menampilkan judul di atas textbox
  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
  // Widget untuk menampilkan textbox
  Widget _buildTextField(String label) {
    return TextFormField(
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
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
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}
