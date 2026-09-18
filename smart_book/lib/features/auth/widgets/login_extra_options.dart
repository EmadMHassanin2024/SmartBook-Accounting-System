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
    final lang = AppLocalizations.of(context);

    // Fallback لترجمة النصوص في حال كانت العودة null لمنع تحطم التطبيق
    final keepMeSignedInText = lang?.keepMeSignedIn ?? 'Keep me signed in';
    final forgotPasswordText = lang?.forgotPassword.toUpperCase() ?? 'FORGOT PASSWORD?';

    return LayoutBuilder(
      builder: (context, constraints) {
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
                keepMeSignedInText,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );

        final forgotPassword = TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
          child: Text(
            forgotPasswordText,
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

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: keepSignedIn),
            const SizedBox(width: 8),
            forgotPassword,
          ],
        );
      },
    );
  }
}