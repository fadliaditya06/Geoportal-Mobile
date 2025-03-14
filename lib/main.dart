import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geoportal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Geoportal'),
        ),
        body: const Center(
          child: Text('Selamat Datang di Aplikasi Geoportal'),
        ),
      ),
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
    );
  }
}
