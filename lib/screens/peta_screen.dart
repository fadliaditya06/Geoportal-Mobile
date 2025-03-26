import 'package:flutter/material.dart';

class PetaScreen extends StatelessWidget {
  const PetaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold( 
      body: Center(
        child: Text(
          'Ini halaman Peta',
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
