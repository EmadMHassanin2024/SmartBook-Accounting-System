
import '../../../../core/packages.dart';
import '../../../../core/widgets/app_text.dart';

class CustomTextFieldCard extends StatelessWidget {
  final String labelTextKey;
  final TextEditingController? controller;
  final String? initialValue;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextFieldCard({
    super.key,
    this.controller,
    this.initialValue,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    required this.labelTextKey,
    this.onChanged,
  }) : assert(
  controller == null || initialValue == null,
  'Cannot provide both a controller and an initialValue',
  );

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          label: AppText(textKey: labelTextKey),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}