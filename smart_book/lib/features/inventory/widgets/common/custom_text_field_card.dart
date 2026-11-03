
import '../../../../core/localization/language.dart';
import '../../../../core/packages.dart';

class CustomTextFieldCard extends StatelessWidget {
 final String labelTextKey;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?S)? validator;
 final void Function(String)? onChanged;

  const CustomTextFieldCard({
    super.key,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    required this.labelTextKey,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    final String translatedLabel = context.translate(labelTextKey);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: context.translate(labelTextKey),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}