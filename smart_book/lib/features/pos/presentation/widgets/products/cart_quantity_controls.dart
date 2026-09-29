import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/core/theme/app_colors.dart';
import '../../../../../core/localization/language_keys.dart';
import '../../../data/models/product_model.dart';
import '../../../logic/PosState.dart';
import '../../../logic/pos_cubit.dart';

class CartQuantityControls extends StatelessWidget {
  final ProductModel product;

  const CartQuantityControls({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PosCubit, PosState, int>(
      selector: (state) {
        if (state is! PosLoaded) return 0;

        // البحث عن العنصر بطريقة آمنة لا تسبب خطأ Null Safety
        final matchingItems = state.cartItems
            .where((item) => item.product.id == product.id);

        if (matchingItems.isEmpty) return 0;

        return matchingItems.first.quantity;
      },
      builder: (context, quantity) {
        final cubit = context.read<PosCubit>();

        if (quantity > 0) {
          return SizedBox(
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.remove),
                  onPressed: quantity > 1
                      ? () => cubit.decreaseCartItem(product)
                      : null,
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Text(
                    '$quantity',
                    key: ValueKey(quantity),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add),
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
            ),
            child: const Text(LanguageKeys.add, style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }
}