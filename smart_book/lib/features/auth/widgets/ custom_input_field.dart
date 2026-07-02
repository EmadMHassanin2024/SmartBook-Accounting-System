// داخل ملف custom_input_field.dart المحدث
import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget { // حولناه لـ Stateful فقط لهذا الـ Widget الصغير
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPassword; // يبدأ مخفي إذا كان حقل كلمة مرور
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5), //
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0054A6), width: 2), //
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            )
                : null,
          ),
        ),
      ],
    );
  }
}