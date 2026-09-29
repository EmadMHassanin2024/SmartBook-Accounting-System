import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/core/theme/app_colors.dart';
import '../../../business_extension/business_extension_area.dart';
import '../../../data/models/product_model.dart';
import '../../../logic/PosState.dart';
import '../../../logic/pos_cubit.dart';

class POSProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const POSProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = product.imagePath != null && product.imagePath!.isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: hasImage
                      ? Image.network(
                    product.imagePath!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                      : _buildPlaceholder(),
                ),

                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'المتبقي: ${product.stock}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${product.price.toStringAsFixed(2)} ر.س',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                BusinessExtensionArea(product: product),

                const SizedBox(height: 8),

                _CartQuantityControls(product: product),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, color: Colors.grey, size: 32),
          SizedBox(height: 4),
          Text('أضف صورة', style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}

class _CartQuantityControls extends StatelessWidget {
  final ProductModel product;

  const _CartQuantityControls({required this.product});

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
            child: const Text('إضافة', style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }
}
