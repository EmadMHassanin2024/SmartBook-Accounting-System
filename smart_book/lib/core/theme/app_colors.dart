import 'package:flutter/material.dart';

class AppColors {
  // 1. الألوان الأساسية (Primary Colors)
  static const Color primaryBlue = Color(0xFF0054A6); // اللون الأزرق الرسمي (قوى)
  static const Color accentRed = Color(0xFFE53935);   // اللون الأحمر لأسماء المؤسسات
  static const Color highlightYellow = Color(0xFFFFFF00); // اللون الأصفر للتحديد تحت المبالغ
  static const Color greyText  = Color(0xFF757575);
  static  const Color qiwaBlue = AppColors.primaryBlue;
  static const Color ghostWhite = Color(0xFFF8F9FB);  // خلفية التطبيق (فاتح جداً / مائل للأبيض)

  // 2. ألوان الخلفيات (Background Colors)
  static const Color scaffoldBg = Color(0xFFF5F6FA);  // رمادي فاتح جداً للخلفية العامة
  static const Color cardBg = Colors.white;            // أبيض ناصع للكروت


  // 3. ألوان الحالة (Status Colors)
  static const Color successGreen = Color(0xFF4CAF50); // الأخضر للفواتير المدفوعة
  static const Color warningOrange = Color(0xFFFFA000); // البرتقالي للفواتير المعلقة
  static const Color errorRed = Color(0xFFD32F2F);      // الأحمر للفواتير المتأخرة أو الملغاة

  // 4. ألوان النصوص والرموز (Text & Icon Colors)
  static const Color textPrimary = Color(0xFF2D2D2D);   // أسود خفيف للنصوص الأساسية
  static const Color textSecondary = Color(0xFF9E9E9E); // رمادي للنصوص الثانوية (رقم، تاريخ)
  static const Color iconGrey = Color(0xFFBDBDBD);      // رمادي للأيقونات غير النشطة
  static const Color dividerColor = Color(0xFFF1F1F1);  // لون الخطوط الفاصلة

  // 5. ألوان الشفافية (Opacity Colors - تستخدم للأيقونات الجانبية)
  static Color successBgLight = successGreen.withOpacity(0.1); // خلفية الأيقونة الخضراء




}