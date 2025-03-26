import 'package:flutter/material.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold( 
      body: Center(
        child: Text(
          'Ini halaman Beranda',
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
