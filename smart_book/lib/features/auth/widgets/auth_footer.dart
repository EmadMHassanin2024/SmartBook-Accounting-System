import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final Color primaryColor;
  final String text;          // النص الثابت
  final String actionText;    // النص القابل للضغط
  final VoidCallback onTap;   // الدالة عند الضغط

  const AuthFooter({
    super.key,
    required this.primaryColor,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(width: 5), // مسافة بسيطة بين النصين
        GestureDetector(
          onTap: onTap, // استخدام الدالة الممررة
          child: Text(
            actionText,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}