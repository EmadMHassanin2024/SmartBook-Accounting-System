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
    final bool hasImage =
        product.imagePath != null && product.imagePath!.isNotEmpty;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          /// صورة المنتج
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

                /// شارة الكمية المتبقية (تصحيح الـ String Interpolation)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'المتبقي: ${product.stock.toInt()}', // 👈 تصحيح هنا
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

          /// البيانات السفلية
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// اسم المنتج
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

                /// السعر (تصحيح الـ String Interpolation)
                Text(
                  '${product.price} ر.س', // 👈 تصحيح هنا
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /// Business Extension Area
                BusinessExtensionArea(product: product),

                const SizedBox(height: 8),

                /// أزرار التحكم
                BlocBuilder<PosCubit, PosState>(
                  builder: (context, state) {
                    final quantity =
                    context.read<PosCubit>().getQuantityInCart(product);

                    if (quantity > 0) {
                      return SizedBox(
                        height: 36,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.remove),
                              onPressed: () => context
                                  .read<PosCubit>()
                                  .decreaseCartItem(product),
                            ),
                            Text(
                              '$quantity', // 👈 تصحيح هنا
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.add),
                              onPressed: product.stock > 0
                                  ? () => context
                                  .read<PosCubit>()
                                  .addToCart(product)
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
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'إضافة',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.add_a_photo_outlined,
            color: Colors.grey,
            size: 32,
          ),
          SizedBox(height: 4),
          Text(
            'أضف صورة',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}