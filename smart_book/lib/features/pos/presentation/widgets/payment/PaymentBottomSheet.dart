import 'package:flutter/material.dart';
import '../../../../../core/localization/language_keys.dart'; // مسار الـ LanguageKeys لديك
import '../../../core/PaymentMethod.dart';

class PaymentBottomSheet extends StatelessWidget {
  final double totalAmount;
  final Function(PaymentMethod method) onConfirmPayment;

  const PaymentBottomSheet({
    super.key,
    required this.totalAmount,
    required this.onConfirmPayment,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان النافذة
          const Text(
            LanguageKeys.choosePaymentMethod,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 15),

          // عرض الإجمالي المطلوب
          Text(
            "${LanguageKeys.requiredTotal}: ${totalAmount.toStringAsFixed(2)} ر.س",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const Divider(height: 30),

          // طرق الدفع
          _paymentOption(
            context,
            title: LanguageKeys.cashMethod,
            icon: Icons.money,
            color: Colors.green,
            method: PaymentMethod.cash,
          ),

          _paymentOption(
            context,
            title: LanguageKeys.cardMethod,
            icon: Icons.credit_card,
            color: Colors.blue,
            method: PaymentMethod.card,
          ),

          _paymentOption(
            context,
            title: LanguageKeys.creditMethod,
            icon: Icons.person_add_alt_1,
            color: Colors.orange,
            method: PaymentMethod.credit,
          ),

          const SizedBox(height: 10),

          // زر الإغلاق
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              LanguageKeys.cancel,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentOption(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required PaymentMethod method,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          Navigator.pop(context);
          onConfirmPayment(method);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}