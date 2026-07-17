import 'package:smart_book/features/auth/auth_exports.dart';
import 'package:smart_book/features/pos/auth_exports.dart';
//عرض "سطر واحد" من الفاتورة. وظيفتها عرض اسم المنتج، كميته المختارة، إجمالي سعر السطر، وتوفر زر "حذف" لإزالة المنتج من السلة

class POSCartItem extends StatelessWidget {
  final CartItemModel item;

  const POSCartItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // 1. اسم المنتج وتفاصيله
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name ?? "منتج بدون اسم",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${(item.product.price ?? 0.0).toStringAsFixed(2)} ر.س",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // 2. أزرار التحكم في الكمية (+ / -)
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQuantityBtn(
                  icon: Icons.remove,
                  color: Colors.grey.shade200,
                  iconColor: Colors.black,
                  onTap: () => context.read<PosCubit>().decreaseCartItem(item.product),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "${item.quantity}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                _buildQuantityBtn(
                  icon: Icons.add,
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  iconColor: AppColors.primaryBlue,
                  onTap: () => context.read<PosCubit>().addToCart(item.product),
                ),
              ],
            ),
          ),

          // 3. الإجمالي الفرعي وزر الحذف
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${item.subTotal.toStringAsFixed(2)} ر.س",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => context.read<PosCubit>().removeFromCart(item.product),
                  child: const Text(
                    "حذف",
                    style: TextStyle(color: AppColors.errorRed, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityBtn({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}