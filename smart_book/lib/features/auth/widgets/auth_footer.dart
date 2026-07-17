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
    final description = Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 13, color: Colors.grey),
    );
    final action = GestureDetector(
      onTap: onTap,
      child: Text(
        actionText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 260) {
          return Column(children: [description, const SizedBox(height: 4), action]);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: description),
            const SizedBox(width: 5),
            action,
          ],
        );
      },
    );
  }
}
