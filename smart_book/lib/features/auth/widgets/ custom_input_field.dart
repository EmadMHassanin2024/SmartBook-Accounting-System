
import 'package:smart_book/features/auth/auth_exports.dart';

class CustomInputField extends StatefulWidget {
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
    _obscureText = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(color: AppColors.greyText, fontSize: 14),
        ),
        TextFormField( // استخدام TextFormField لدعم الـ Validation
          controller: widget.controller,
          obscureText: _obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) return 'هذا الحقل مطلوب';
            return null;
          },
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color:AppColors.greyText, width: 0.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color:  AppColors.primaryBlue, width: 2),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20,
                color:AppColors.greyText,
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