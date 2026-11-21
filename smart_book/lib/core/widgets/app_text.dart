import 'package:flutter/material.dart';
import '../localization/language.dart';
import '../theme/app_colors.dart';
// تأكد من استيراد ملف AppColors هنا إذا لم يكن مضمناً تلقائياً

class AppText extends StatelessWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final double? height;

  const AppText({
    super.key,
    required this.textKey,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.fontFamily,
    this.height,
  });

  const AppText.title(
      this.textKey, {
        super.key,
        this.style,
        this.textAlign,
        this.maxLines = 1,
        this.overflow = TextOverflow.ellipsis,
        this.fontSize = 18,
        this.fontWeight = FontWeight.bold,
        this.color = AppColors.textPrimary,
        this.fontFamily,
        this.height,
      });

  const AppText.body(
      this.textKey, {
        super.key,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.fontSize = 14,
        this.fontWeight = FontWeight.normal,
        this.color = AppColors.textPrimary,
        this.fontFamily,
        this.height,
      });

  const AppText.caption(
      this.textKey, {
        super.key,
        this.style,
        this.textAlign,
        this.maxLines = 1,
        this.overflow = TextOverflow.ellipsis,
        this.fontSize = 12,
        this.fontWeight = FontWeight.w500,
        this.color = AppColors.textSecondary,
        this.fontFamily,
        this.height,
      });

  @override
  Widget build(BuildContext context) {
    const String defaultFontFamily = 'Cairo';

    final baseStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontFamily: defaultFontFamily,
      color: AppColors.textPrimary,
    ) ??
        const TextStyle(
          fontFamily: defaultFontFamily,
          color: AppColors.textPrimary,
        );

    final effectiveStyle = baseStyle.merge(style).copyWith(
      fontSize: fontSize ?? style?.fontSize ?? baseStyle.fontSize,
      fontWeight: fontWeight ?? style?.fontWeight ?? baseStyle.fontWeight,
      color: color ?? style?.color ?? baseStyle.color,
      fontFamily: fontFamily ?? style?.fontFamily ?? baseStyle.fontFamily,
      height: height ?? style?.height ?? baseStyle.height,
    );

    return Text(
      context.translate(textKey),
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}