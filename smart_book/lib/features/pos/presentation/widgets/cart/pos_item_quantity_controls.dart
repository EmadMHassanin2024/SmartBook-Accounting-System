import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/core/theme/app_colors.dart';
import '../../../../../core/localization/language_keys.dart';
import '../../../data/models/product_model.dart';
import '../../../logic/PosState.dart';
import '../../../logic/pos_cubit.dart';

class POSQuantityControls extends StatelessWidget {
  final ProductModel product;
  final bool compact;

  const POSQuantityControls({
    super.key,
    required this.product,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PosCubit, PosState, int>(
      selector: (state) {
        if (state is! PosLoaded) return 0;
        final matchingItems = state.cartItems
            .where((item) => item.product.id == product.id);
        if (matchingItems.isEmpty) return 0;
        return matchingItems.first.quantity;
      },
      builder: (context, quantity) {
        final cubit = context.read<PosCubit>();

        if (quantity > 0) {
          return SizedBox(
            height: compact ? 32 : 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBtn(
                  icon: Icons.remove,
                  onPressed: quantity > 1
                      ? () => cubit.decreaseCartItem(product)
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                _buildBtn(
                  icon: Icons.add,
                  onPressed: product.stock > quantity
                      ? () => cubit.addToCart(product)
                      : null,
                ),
              ],
            ),
          );
        }

        return SizedBox(
          width: double.infinity,
          height: 36,
          child: ElevatedButton(
            onPressed: product.stock > 0
                ? () => cubit.addToCart(product)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              LanguageKeys.add,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBtn({required IconData icon, required VoidCallback? onPressed}) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(icon, size: 16),
      onPressed: onPressed,
    );
  }
}