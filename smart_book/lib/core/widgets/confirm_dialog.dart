
import 'package:smart_book/features/auth/auth_exports.dart';
import '../../../../../core/localization/language_keys.dart';

class ConfirmDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = LanguageKeys.delete,
    String cancelText = LanguageKeys.cancel,
    Color confirmColor = AppColors.errorRed,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text(cancelText),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text(
                confirmText,
                style: TextStyle(color: confirmColor),
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    ) ??
        false;
  }
}