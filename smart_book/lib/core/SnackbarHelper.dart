import 'package:flutter/material.dart';

class  SnackbarHelper {
  // المفتاح العالمي لإظهار الـ SnackBar من أي مكان
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
  GlobalKey<ScaffoldMessengerState>();

  static void show(
      String message,
      Color backgroundColor, {
        IconData? icon,
      }) {
    messengerKey.currentState?.hideCurrentSnackBar();
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // الدوال الموحدة للاستدعاء السريع
  static void showSuccess(String message) {
    show(message, const Color(0xFF4CAF50), icon: Icons.check_circle_outline);
  }

  static void showError(String message) {
    show(message, const Color(0xFFE53935), icon: Icons.error_outline);
  }

  static void showWarning(String message) {
    show(message, const Color(0xFFFFB300), icon: Icons.warning_amber_rounded);
  }
}