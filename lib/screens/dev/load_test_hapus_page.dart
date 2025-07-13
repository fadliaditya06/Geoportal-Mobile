import 'package:flutter/material.dart';
import 'package:geoportal_mobile/performance/load_test_hapus_data.dart';

class LoadTestHapusPage extends StatefulWidget {
  const LoadTestHapusPage({super.key});

  @override
  State<LoadTestHapusPage> createState() => _LoadTestHapusPageState();
}

class _LoadTestHapusPageState extends State<LoadTestHapusPage> {
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Load Testing Hapus Data')),
      body: Center(
        child:
            _isRunning
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                  label: const Text('Jalankan Load Test Hapus'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () async {
                    setState(() => _isRunning = true);

                    await runLoadTestHapusData(
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
