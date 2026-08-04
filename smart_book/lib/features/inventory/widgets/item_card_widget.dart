import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../pos/data/models/product_model.dart';

class ItemCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAdjustmentPressed;

  const ItemCardWidget({super.key, required this.product, required this.onAdjustmentPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // القسم الأيمن: أيقونة الصنف
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.inventory_2_outlined, color: AppColors.primaryBlue, size: 28),
          ),
          const SizedBox(width: 12),

          // القسم الأوسط: بيانات الصنف
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "باركود: ${product.barcode.isEmpty ? 'بدون باركود' : product.barcode}",
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),

          // القسم الأيسر: السعر، المخزون، وزر الجرد
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${product.price.toStringAsFixed(2)} ريال",
                style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              // سطر يحتوي على الرصيد وزر الجرد
              Row(
                children: [
                  // أيقونة الجرد
                  GestureDetector(
                    onTap: onAdjustmentPressed,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.edit_note, size: 18, color: AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // رصيد المخزون
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.stock > 0 ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "الرصيد: ${product.stock}",
                      style: TextStyle(
                          color: product.stock > 0 ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}