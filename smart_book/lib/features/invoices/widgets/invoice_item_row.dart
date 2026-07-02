import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../logic/invoice_cubit.dart';
import '../models/invoice_item_model.dart';

/// وظيفة الملف: يتحكم في عرض كل صنف تمت إضافته للفاتورة (صف تفاعلي ديناميكي).
class InvoiceItemRow extends StatelessWidget {
  final int index;
  final InvoiceItemModel item;

  const InvoiceItemRow({
    super.key,
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg, // تم الربط بالخلفية البيضاء للبطاقة
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // 1. تفاصيل الصنف (الاسم، السعر الفردي، وزر الحذف)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.unitPrice.toStringAsFixed(2)} ريال / قطعة",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                // زر الحذف السريع باللون الأحمر كما في التصميم
                TextButton(
                  onPressed: () => context.read<InvoiceCubit>().removeItem(index),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 24),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "حذف",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. متحكم الكمية الديناميكي (+ و -)
          Container(
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg, // الخلفية الرمادية الفاتحة للمتحكم
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // زر النقصان (-)
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.grey),
                  onPressed: () => context.read<InvoiceCubit>().decrementQuantity(index),
                ),
                // عرض الكمية الحالية
                Text(
                  "${item.quantity}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                // زر الزيادة (+)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20, color: AppColors.primaryBlue),
                  onPressed: () => context.read<InvoiceCubit>().incrementQuantity(index),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // 3. الإجمالي النهائي للصنف المحسوب تلقائياً مع الضريبة
          Expanded(
            flex: 2,
            child: Text(
              "${item.total.toStringAsFixed(2)} ريال",
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primaryBlue, // اللون الأزرق لتمييز الناتج النهائي
              ),
            ),
          ),
        ],
      ),
    );
  }
}