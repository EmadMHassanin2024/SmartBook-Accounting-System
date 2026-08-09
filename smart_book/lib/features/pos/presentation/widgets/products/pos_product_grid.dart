import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/features/pos/auth_exports.dart';
import 'package:smart_book/features/pos/presentation/widgets/products/pos_product_card.dart';

import '../../../logic/PosState.dart';
import '../../../logic/pos_cubit.dart';

class POSProductGrid extends StatelessWidget {
  const POSProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        if (state is PosLoadingProducts) return const Center(child: CircularProgressIndicator());
        if (state is PosError) return Center(child: Text(state.message));
        if (state is PosLoaded) {
          // 💡 تصفية المنتجات بناءً على النشاط النشط حالياً في نقاط البيع
          final activeExtension = context.read<PosCubit>().activeExtension;
          String currentActivityType = 'general';

          if (activeExtension != null) {
            // تحديد نوع النشاط بناءً على الـ Extension المفعل (يمكنك ضبط الاسم حسب نموذج الـ Extension لديك)
            if (activeExtension.runtimeType.toString().toLowerCase().contains('pharmacy')) {
              currentActivityType = 'pharmacy';
            } else if (activeExtension.runtimeType.toString().toLowerCase().contains('restaurant')) {
              currentActivityType = 'restaurant';
            }
          }

          // تصفية المنتجات الصارمة
          final filteredProducts = state.products.where((product) {
            // افترضنا أن حقل itemType موجود في الـ ProductModel
            return product.itemType == currentActivityType;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "ابحث عن منتج...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (query) {
                    // دالة البحث
                  },
                ),
              ),
           
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(child: Text("لا توجد منتجات مسجلة في هذا القسم"))
                    : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 0.82,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return POSProductCard(
                      product: product,
                      onTap: product.stock > 0 ? () => context.read<PosCubit>().addToCart(product) : null,
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}