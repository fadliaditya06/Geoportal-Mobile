import 'package:flutter/material.dart';
import 'package:geoportal_mobile/screens/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscure = true;

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
                  'assets/images/logo-geoportal.png',
                  width: 200,
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
                        value: null,
                        hint: const Text(
                          "Pilih Peran",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        items: ['Pengguna', 'Admin'].map((role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(
                              role,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {},
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Input Nama Depan
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          labelText: 'Nama Depan',
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
                      ),
                      const SizedBox(height: 20),
                      // Input Nama Belakang
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          labelText: 'Nama Belakang',
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
                      ),
                      const SizedBox(height: 20),
                      // Input Email
                      TextFormField(
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
                      ),
                      const SizedBox(height: 20),
                      // Input Kata Sandi
                      TextFormField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
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
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Input Konfirmasi Kata Sandi
                      TextFormField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
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
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tombol Daftar
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            // Navigasi ke halaman Login
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF358666),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
