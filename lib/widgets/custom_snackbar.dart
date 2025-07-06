import 'package:flutter/material.dart';

bool isTestMode = false;

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  required bool isSuccess,
}) {
  if (isTestMode) return;
  final backgroundColor = isSuccess ? const Color(0xFF358666) : const Color(0xFFEA3535);
  final icon = isSuccess ? Icons.check_circle : Icons.error;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: () {
            scaffoldMessenger.hideCurrentSnackBar();
          },
          child: const Icon(Icons.close, color: Colors.white),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    duration: const Duration(seconds: 2),
  );

  scaffoldMessenger.showSnackBar(snackBar);
}
