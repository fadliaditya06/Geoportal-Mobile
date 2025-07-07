import 'package:flutter/material.dart';
import 'package:geoportal_mobile/controllers/register_controller.dart';
import 'package:geoportal_mobile/screens/auth/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController controller = RegisterController();
  bool isLoading = false;
  bool _isObscure = true;
  bool _isConfirmObscure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF64C38F),
                  Color(0xFFB0E1C6),
                  Color(0xFFFBFFFC),
                ],
                stops: [0.0, 0.18, 0.67],
              ),
            ),
          ),
          // Konten Logo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Image.asset(
                  'assets/images/logo/logo-geoportal.png',
                  width: 150,
                ),
              ],
            ),
          ),
          // Box untuk Form Register
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFFFFF),
                      Color(0xFFB0E1C6),
                    ],
                    stops: [0.2, 0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF358666),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Dropdown untuk memilih peran
                      DropdownButtonFormField<String>(
                        value: controller.selectedRole,
                        hint: Text(
                          "Pilih Peran",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        items: ['Pengguna', 'Admin'].map((role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(
                              role,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newRole) {
                          setState(() {
                            controller.selectedRole = newRole;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silahkan pilih peran';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.black),
                          filled: true,
                          fillColor: const Color(0xFFB0E1C6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Input Email
                      TextFormField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Colors.black),
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFB0E1C6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silahkan masukkan email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Input Nama Lengkap
                      TextFormField(
                        controller: controller.namaController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline,
                              color: Colors.black),
                          labelText: 'Nama Lengkap',
                          labelStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFB0E1C6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silahkan masukkan nama lengkap';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Input Alamat
                      TextFormField(
                        controller: controller.alamatController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.home_outlined,
                              color: Colors.black),
                          labelText: 'Alamat',
                          labelStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFB0E1C6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silahkan masukkan alamat';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Input Kata Sandi
                      TextFormField(
                        controller: controller.kataSandiController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Colors.black),
                          labelText: 'Kata Sandi',
                          labelStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFB0E1C6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silahkan masukkan kata sandi';
                          }
                          if (value.length < 6) {
                            return 'Kata sandi minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Input Konfirmasi Kata Sandi
                      TextFormField(
                        controller: controller.konfirmasiKataSandiController,
                        obscureText: _isConfirmObscure,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Colors.black),
                          labelText: 'Konfirmasi Kata Sandi',
                          labelStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFB0E1C6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF358666), width: 1),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _isConfirmObscure = !_isConfirmObscure;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silahkan konfirmasi kata sandi';
                          }
                          if (value != controller.kataSandiController.text) {
                            return 'Kata sandi tidak cocok';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Tombol Daftar
                      SizedBox(
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
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await controller.register(context);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                            child: isLoading
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
                                    'Daftar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Navigasi ke halaman login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sudah memiliki akun?',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "Masuk",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
