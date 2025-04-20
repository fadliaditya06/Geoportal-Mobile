import 'package:flutter/material.dart';

class UbahProfilScreen extends StatelessWidget {
  const UbahProfilScreen({super.key});

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
              // Ikon Profil
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 80,
                      backgroundColor: Color(0xFF358666),
                      child: Icon(Icons.person, size: 100, color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xFFB0E1C6),
                        child: Icon(Icons.camera_alt_outlined,
                            size: 24, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
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
