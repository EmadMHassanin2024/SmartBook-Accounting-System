import 'package:flutter/material.dart';

class CustomSubmitButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Color primaryColor;
  final String buttonText;
  final bool isLoading;
  final VoidCallback onPressed;

  const CustomSubmitButtonWidget({
    super.key,
    required this.formKey,
    required this.primaryColor,
    required this.buttonText,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (formKey.currentState!.validate()) {
            onPressed();
          }
        },
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}