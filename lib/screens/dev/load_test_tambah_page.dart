import 'package:flutter/material.dart';
import 'package:geoportal_mobile/performance/load_test_tambah_data.dart';

class LoadTestTambahPage extends StatefulWidget {
  const LoadTestTambahPage({super.key});

  @override
  State<LoadTestTambahPage> createState() => _LoadTestTambahPageState();
}

class _LoadTestTambahPageState extends State<LoadTestTambahPage> {
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Load Testing Tambah Data')),
      body: Center(
        child:
            _isRunning
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  child: const Text('Jalankan Load Test Tambah'),
                  onPressed: () async {
                    setState(() => _isRunning = true);
                    await runLoadTestTambahData(
                      context: context,
                      totalUsers: 10,
                      rampUpSeconds: 5,
                    );
                    setState(() => _isRunning = false);
                  },
                ),
      ),
    );
  }
}
