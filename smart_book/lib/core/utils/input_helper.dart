import 'package:flutter/material.dart';

/// كلاس مساعد لتنقية وتجهيز مدخلات الحقول النصية عبر الواجهات
abstract class InputHelper {
  /// تحويل النص الفارغ أو المحتوي على مسافات فقط إلى null
  /// مفيد جداً قبل إرسال البيانات الاختيارية إلى الكيوبت أو السيرفر
  static String? getOptionalText(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  /// تحويل النص المدخل إلى رقم مزدوج (Double) آمن مع إرجاع قيمة افتراضية عند الخطأ
  static double parseDouble(TextEditingController controller, {double defaultValue = 0.0}) {
    final text = controller.text.trim();
    return double.tryParse(text) ?? defaultValue;
  }

  /// تحويل النص المدخل إلى رقم صحيح (Int) آمن
  static int parseInt(TextEditingController controller, {int defaultValue = 0}) {
    final text = controller.text.trim();
    return int.tryParse(text) ?? defaultValue;
  }

  /// تنظيف وتجهيز النص المدخل (مسح المسافات الزائدة في البداية والنهاية)
  static String getCleanText(TextEditingController controller) {
    return controller.text.trim();
  }
}