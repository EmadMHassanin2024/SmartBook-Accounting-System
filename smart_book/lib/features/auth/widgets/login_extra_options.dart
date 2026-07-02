import 'package:flutter/material.dart';
import 'package:smart_book/l10n/app_localizations.dart';

class LoginExtraOptions extends StatelessWidget {
  final Color primaryColor;
  final bool isChecked; // القيمة الحالية
  final ValueChanged<bool?> onChanged; // دالة التحديث

  const LoginExtraOptions({
    super.key,
    required this.primaryColor,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: isChecked, // ربط القيمة
                onChanged: onChanged, // ربط التحديث
                activeColor: primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(lang.keepMeSignedIn, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        TextButton(
          onPressed: () { /* التنقل لنسيت كلمة المرور */ },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(lang.forgotPassword.toUpperCase(),
              style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}