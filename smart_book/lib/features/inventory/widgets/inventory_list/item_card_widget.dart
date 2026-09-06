


import 'package:smart_book/features/inventory/auth_exports.dart';

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
                  "${context.lang.barcode}: ${product.barcode.isEmpty ? context.lang.noBarcode : product.barcode}",
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),

          // القسم الأيسر: السعر، المخزون، وأزرار التحكم (تعديل، حذف، جرد)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${product.price.toStringAsFixed(2)} ${context.lang.currency}",
                style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              // سطر يحتوي على أزرار التعديل، الحذف، الجرد، ورصيد المخزون
              Row(
                children: [
                  // 🌟 زر التعديل
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddProductScreen(productToEdit: product),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.edit, size: 16, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // 🌟 زر الحذف
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("تأكيد الحذف"),
                          content: Text("هل أنت متأكد من حذف ${product.name}؟"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text("إلغاء"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                int productId = int.tryParse(product.id.toString()) ?? 0;
                                context.read<InventoryCubit>().deleteProduct(productId);
                              },
                              child: const Text("حذف", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 6),

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
                  const SizedBox(width: 6),

                  // رصيد المخزون
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.stock > 0 ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${context.lang.stock}: ${product.stock}",
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