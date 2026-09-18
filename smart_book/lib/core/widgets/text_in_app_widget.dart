import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class TextInAppWidget extends StatelessWidget {
  final String text; // يستقبل LanguageKeys مباشرة
  final double? textSize;
  final int? fontWeightIndex; // أو FontWeight حسب تصميمك
  final Color? textColor;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TextInAppWidget({
    super.key,
    required this.text,
    this.textSize,
    this.fontWeightIndex,
    this.textColor,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    // جلب الترجمة تلقائياً بناءً على المفتاح المُمرر
    final translatedText = AppLocalizations.of(context)?.translate(text) ?? text;

    return Text(
      translatedText,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: textSize,
        color: textColor,
        fontWeight: _getFontWeight(fontWeightIndex),
      ),
    );
  }

  // دالة مساعدة لتحديد سمك الخط بناءً على الرقم (اختياري حسب نظام مشروعك)
  FontWeight _getFontWeight(int? index) {
    switch (index) {
      case 7:
        return FontWeight.bold;
      case 8:
        return FontWeight.w800;
      case 6:
        return FontWeight.w600;
      case 5:
        return FontWeight.w500;
      default:
        return FontWeight.normal;
    }
  }
}