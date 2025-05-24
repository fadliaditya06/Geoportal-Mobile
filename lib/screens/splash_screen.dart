import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  // Animasi untuk gerakan logo dari atas ke tengah layar
  late AnimationController _logoDropController;
  late Animation<double> _logoDropAnimation;
  
  // Animasi untuk pergeseran logo ke kiri
  late AnimationController _logoShiftController;
  late Animation<double> _logoShiftAnimation;

  // Animasi untuk menampilkan teks secara perlahan
  late AnimationController _textFadeController;
  late Animation<double> _textFadeAnimation;

  bool _showText = false;

  @override
  void initState() {
    super.initState();

    // Inisialisasi animasi jatuh dari atas
    _logoDropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoDropAnimation = Tween<double>(begin: -250, end: 0).animate(
      CurvedAnimation(parent: _logoDropController, curve: Curves.easeOut),
    );

    // Inisialisasi animasi geser ke kiri
    _logoShiftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _logoShiftAnimation = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _logoShiftController, curve: Curves.easeInOut),
    );

    // Inisialisasi animasi fade in untuk teks
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textFadeAnimation = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeIn),
    );

    _startAnimation();
  }

  // Mengatur urutan animasi dan navigasi ke halaman onboarding
  Future<void> _startAnimation() async {
    await _logoDropController.forward();
    await _logoShiftController.forward();

    setState(() {
      _showText = true;
    });

    await _textFadeController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    Navigator.pushNamed(context, '/onboarding');
  }

  @override
  void dispose() {
    _logoDropController.dispose();
    _logoShiftController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFBFFFC),
              Color(0xFFB0E1C6),
              Color(0xFF64C38F),
            ],
            stops: [0.0, 0.84, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation:
                Listenable.merge([_logoDropController, _logoShiftController]),
            builder: (context, child) {
              return Transform.translate(
                offset:
                    Offset(_logoShiftAnimation.value, _logoDropAnimation.value),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo/logo-geoportal.png',
                      width: 150,
                      height: 150,
                    ),
                    if (_showText)
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            'Geoportal',
                            style: TextStyle(
                              fontSize: 38,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
