import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/core/theme/app_colors.dart';
import 'package:smart_book/features/pos/auth_exports.dart';

// كارت المنتج. إذا لم يكن المنتج في السلة يظهر زر "أضف"،
// وإذا تمت إضافته يتحول إلى أزرار تحكم بالكمية (+/-)

class POSProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const POSProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // التحقق مما إذا كان للمنتج صورة
    final bool hasImage = product.imagePath != null && product.imagePath!.isNotEmpty;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: hasImage
                      ? Image.network(product.imagePath!, fit: BoxFit.cover, width: double.infinity)
                      : Container(
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo_outlined, color: Colors.grey, size: 32),
                        SizedBox(height: 4),
                        Text("أضف صورة", style: TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      "المتبقي: ${product.stock.toInt()}",
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                Text("${product.price} ر.س", style: const TextStyle(color: AppColors.primaryBlue)),
                const SizedBox(height: 5),
                // استخدام BlocBuilder لضمان تحديث الأزرار والكمية فور تغييرها في السلة
                BlocBuilder<PosCubit, PosState>(
                  builder: (context, state) {
                    final int quantityInCart = context.read<PosCubit>().getQuantityInCart(product);

                    return quantityInCart > 0
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: () => context.read<PosCubit>().decreaseCartItem(product),
                        ),
                        Text("$quantityInCart", style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: product.stock > 0 ? () => context.read<PosCubit>().addToCart(product) : null,
                        ),
                      ],
                    )
                        : ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        minimumSize: const Size(double.infinity, 35),
                      ),
                      child: const Text("أضف", style: TextStyle(color: Colors.white)),
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
}