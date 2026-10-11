import 'package:flutter/material.dart';

import '../localization/language.dart';


class AppButton extends StatelessWidget {
  final String titleKey;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.titleKey,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: Text(
        context.translate(titleKey),
        style: TextStyle(color: textColor ?? Colors.white),
      ),
    );
  }
}