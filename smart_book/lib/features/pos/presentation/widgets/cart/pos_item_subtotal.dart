
import 'package:smart_book/features/auth/auth_exports.dart';

import '../../../../../core/localization/language_keys.dart';
import '../../../../../core/widgets/confirm_dialog.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../logic/pos_cubit.dart';

class POSItemSubtotal extends StatelessWidget {
  final CartItemModel item;

  const POSItemSubtotal({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Animated subtotal
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Text(
            "${item.subTotal.toStringAsFixed(2)} ر.س",
            key: ValueKey(item.subTotal),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
        ),

        const SizedBox(height: 4),

        Tooltip(
          message: LanguageKeys.deleteProductTooltip,
          child: InkWell(
            onTap: () async {
              final confirm = await ConfirmDialog.show(
                context: context,
                title: LanguageKeys.confirmDeleteTitle,
                message: LanguageKeys.confirmDeleteMessage,
              );

              if (confirm) {
                context.read<PosCubit>().removeFromCart(item.product);
              }
            },
            borderRadius: BorderRadius.circular(6),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, color: AppColors.errorRed, size: 14),
                SizedBox(width: 4),
                Text(
                  LanguageKeys.delete,
                  style: TextStyle(
                    color: AppColors.errorRed,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}