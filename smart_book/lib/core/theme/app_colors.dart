import 'package:flutter/material.dart';

class AppColors {
  // ============================================================
  // 1. Primary Colors
  // ============================================================

  static const Color primaryBlue = Color(0xFF0054A6);
  static const Color accentRed = Color(0xFFE53935);
  static const Color highlightYellow = Color(0xFFFFFF00);
  static const Color greyText = Color(0xFF757575);

  // يمكن استخدامها كاسم بديل للون الأساسي
  static const Color qiwaBlue = primaryBlue;

  static const Color ghostWhite = Color(0xFFF8F9FB);

  // ============================================================
  // 2. Background Colors
  // ============================================================

  static const Color scaffoldBg = Color(0xFFF5F6FA);
  static const Color cardBg = Colors.white;

  // ============================================================
  // 3. Status Colors
  // ============================================================

  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFFA000);
  static const Color errorRed = Color(0xFFD32F2F);

  // ============================================================
  // 4. Text & Icon Colors
  // ============================================================

  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color iconGrey = Color(0xFFBDBDBD);
  static const Color dividerColor = Color(0xFFF1F1F1);

  // ============================================================
  // 5. Light Background Colors
  // ============================================================

  static final Color successBgLight =
  successGreen.withValues(alpha: 0.1);
}