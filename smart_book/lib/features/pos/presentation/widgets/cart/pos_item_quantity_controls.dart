import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/features/auth/auth_exports.dart';
import '../../../../../core/localization/language_keys.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../logic/pos_cubit.dart';

class POSItemQuantityControls extends StatelessWidget {
  final CartItemModel item;

  const POSItemQuantityControls({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final canDecrease = item.quantity > 1;
    final canIncrease = item.product.stock > item.quantity;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildQuantityBtn(
          icon: Icons.remove,
          color: Colors.grey.shade200,
          iconColor: canDecrease ? Colors.black : Colors.grey,
          onTap: canDecrease
              ? () => context.read<PosCubit>().decreaseCartItem(item.product)
              : null,
          tooltip: LanguageKeys.increaseQuantity,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              "${item.quantity}",
              key: ValueKey(item.quantity),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),

        _buildQuantityBtn(
          icon: Icons.add,
          color: AppColors.primaryBlue.withValues(alpha: 0.1),
          iconColor: canIncrease ? AppColors.primaryBlue : Colors.grey,
          onTap: canIncrease
              ? () => context.read<PosCubit>().addToCart(item.product)
              : null,
          tooltip:LanguageKeys.decreaseQuantity,
        ),
      ],
    );
  }

  Widget _buildQuantityBtn({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback? onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
      ),
    );
  }
}
