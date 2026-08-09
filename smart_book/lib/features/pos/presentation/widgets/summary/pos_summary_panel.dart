import 'package:flutter/material.dart';
import 'package:smart_book/features/auth/auth_exports.dart';

import '../../../core/PaymentMethod.dart';
import '../../../logic/pos_cubit.dart';
import '../payment/PaymentBottomSheet.dart';

///--------------------------------------------------------------
/// لوحة الملخص العام (تم تعديل زر الدفع ليدعم خيارات الدفع المنبثقة)
///--------------------------------------------------------------
class POSSummaryPanel extends StatelessWidget {
  final double subTotal;       // المجموع قبل الضريبة القادم من السلة
  final double vatAmount;      // قيمة الضريبة المحسوبة (15%)
  final double totalAmount;    // الإجمالي النهائي الشامل للضريبة
  final VoidCallback onConfirm; // الدالة الممررة لحفظ الفاتورة (يمكن استبدالها أو دمجها حسب الحاجة)

  const POSSummaryPanel({
    super.key,
    required this.subTotal,
    required this.vatAmount,
    required this.totalAmount,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg, // لون الخلفية الموحد للكروت بالنظام
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. المجموع قبل الضريبة
            _rowAmount("المجموع", subTotal.toStringAsFixed(2)),

            // 2. قيمة الضريبة المحسوبة
            _rowAmount("الضريبة (15%)", vatAmount.toStringAsFixed(2)),

            const Divider(color: AppColors.dividerColor, height: 20),

            // 3. الإجمالي النهائي المطلوب سداده
            _rowAmount("الإجمالي النهائي", totalAmount.toStringAsFixed(2), isTotal: true),

            const SizedBox(height: 12),

            // 4. زر التأكيد والدفع وإظهار خيارات الدفع
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // إظهار نافذة خيارات الدفع المنبثقة مع تمرير الإجمالي النهائي
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (sheetContext) => PaymentBottomSheet(
                      totalAmount: totalAmount,
                      onConfirmPayment: (PaymentMethod method) {
                        // إرسال طريقة الدفع للـ Cubit لإنهاء الفاتورة وترحيلها
                        context.read<PosCubit>().checkoutWithMethod(method);
                      },
                    ),
                  );
                },
                child: const Text(
                  "تأكيد ودفع (F10)",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // أداة بناء أسطر المبالغ المالية المنسقة
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