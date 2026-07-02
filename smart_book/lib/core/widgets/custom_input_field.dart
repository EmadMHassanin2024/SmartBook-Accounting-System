import 'package:flutter/material.dart';

class CustomAuthInputField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  const CustomAuthInputField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false, // القيمة الافتراضية أنه ليس كلمة مرور
  });

  @override
  Widget build(BuildContext context) {
    const Color qiwaBlue = Color(0xFF0054A6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: qiwaBlue, width: 2),
            ),
            suffixIcon: isPassword
                ? const Icon(Icons.visibility_outlined, size: 20)
                : null,
          ),
        ),
      ],
    );
  }
}