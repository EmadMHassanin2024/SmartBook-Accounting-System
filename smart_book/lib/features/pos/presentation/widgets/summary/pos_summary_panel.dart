import 'package:flutter/material.dart';
import 'package:smart_book/core/localization/language_keys.dart';
import 'package:smart_book/features/pos/auth_exports.dart';
import 'pos_checkout_button.dart';

class POSSummaryPanel extends StatelessWidget {
  final double subTotal;
  final double vatAmount;
  final double totalAmount;
  final VoidCallback? onConfirm;

  const POSSummaryPanel({
    super.key,
    required this.subTotal,
    required this.vatAmount,
    required this.totalAmount,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _rowAmount(LanguageKeys.subTotal, subTotal.toStringAsFixed(2)),
            _rowAmount(LanguageKeys.vatTax, vatAmount.toStringAsFixed(2)),

            const Divider(color: AppColors.dividerColor, height: 20),

            _rowAmount(
              LanguageKeys.finalTotal,
              totalAmount.toStringAsFixed(2),
              isTotal: true,
            ),

            const SizedBox(height: 12),

            POSCheckoutButton(
              totalAmount: totalAmount,
              onConfirm: onConfirm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowAmount(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            "$value ر.س",
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: FontWeight.bold,
              color: isTotal ? AppColors.primaryBlue : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}