import 'package:flutter/material.dart';

void showOtpDialog({
  required BuildContext context,
  required TextEditingController otpController,
  required VoidCallback onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Enter OTP'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
        ),
      ]),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: const Text('Verify'),
        ),
      ],
    ),
  );
}
