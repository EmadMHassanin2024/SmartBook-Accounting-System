import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/features/pos/auth_exports.dart'; // تأكد من استيراد المسار الصحيح للـ Cubit و Models
// الشاشة الرئيسية لعرض المنتجات. //، شريط بحث .
class POSProductGrid extends StatelessWidget {
  const POSProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        if (state is PosLoadingProducts) return const Center(child: CircularProgressIndicator());
        if (state is PosError) return Center(child: Text(state.message));
        if (state is PosLoaded) {
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
                    // يمكنك هنا استدعاء دالة البحث في الـ Cubit لاحقاً
                  },
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FilterChip(label: const Text("الكل"), onSelected: (_) {}),
                    const SizedBox(width: 8),
                    FilterChip(label: const Text("مواد غذائية"), onSelected: (_) {}),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
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