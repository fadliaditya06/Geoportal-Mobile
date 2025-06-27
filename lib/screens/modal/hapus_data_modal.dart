import 'package:flutter/material.dart';

Future<void> showDeleteDataDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Image.asset(
            'assets/images/icon/permintaan-hapus-disetujui.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin mengapus data ini?',
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 5.0),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8D8D8),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA3535),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  child: const Text(
                    'Konfirmasi',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
