import 'package:flutter/material.dart';
import 'package:smart_book/l10n/app_localizations.dart';

class LoginExtraOptions extends StatelessWidget {
  final Color primaryColor;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const LoginExtraOptions({
    super.key,
    required this.primaryColor,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        // نرفع القيمة قليلاً لضمان مرونة أكبر
        final isNarrow = constraints.maxWidth < 300;

        final keepSignedIn = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: isChecked,
                onChanged: onChanged,
                activeColor: primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                lang.keepMeSignedIn,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                overflow: TextOverflow.ellipsis, // حل إضافي لمنع النص من الخروج
              ),
            ),
          ],
        );

        final forgotPassword = TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 4)),
          child: Text(
            lang.forgotPassword.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [keepSignedIn, forgotPassword],
          );
        }

        // في الشاشات العريضة، نستخدم Expanded لضمان توزيع المساحة
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: keepSignedIn), // يأخذ المساحة المتبقية
            const SizedBox(width: 8), // مسافة فاصلة
            forgotPassword, // يأخذ حجمه الطبيعي
          ],
        );
      },
    );
  }
}