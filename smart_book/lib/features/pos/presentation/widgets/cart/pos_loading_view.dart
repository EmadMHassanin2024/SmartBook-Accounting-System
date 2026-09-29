import 'package:flutter/material.dart';
import '../../../../../core/localization/language_keys.dart';

/// شاشة التحميل العامة (تحميل بيانات المنتجات – تحميل السلة – إلخ)
class POSLoadingView extends StatelessWidget {
  const POSLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 45,
            height: 45,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            LanguageKeys.loadingMessage,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// شاشة تنفيذ عملية مهمة (الدفع – حفظ الفاتورة – تطبيق خصم)
class POSSubmittingView extends StatelessWidget {
  const POSSubmittingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 55,
            height: 55,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            LanguageKeys.submittingMessage,
            style: TextStyle(
              fontSize: 15,
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}