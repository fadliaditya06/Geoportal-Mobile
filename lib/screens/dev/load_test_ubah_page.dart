import 'package:flutter/material.dart';
import 'package:geoportal_mobile/performance/load_test_ubah_data.dart';

class LoadTestUbahPage extends StatefulWidget {
  const LoadTestUbahPage({super.key});

  @override
  State<LoadTestUbahPage> createState() => _LoadTestUbahPageState();
}

class _LoadTestUbahPageState extends State<LoadTestUbahPage> {
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Load Testing Ubah Data')),
      body: Center(
        child:
            _isRunning
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                  label: const Text('Jalankan Load Test Ubah'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () async {
                    setState(() => _isRunning = true);

                    // Jalankan load test ubah data
                    await runLoadTestUbahData(
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
