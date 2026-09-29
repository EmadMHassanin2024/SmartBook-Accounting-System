import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/core/localization/language_keys.dart';
import 'package:smart_book/features/pos/auth_exports.dart';
import 'package:smart_book/features/pos/presentation/widgets/products/pos_product_card.dart';
import 'dart:async';

class POSProductGrid extends StatefulWidget {
  const POSProductGrid({super.key});

  @override
  State<POSProductGrid> createState() => _POSProductGridState();
}

class _POSProductGridState extends State<POSProductGrid> {
  Timer? _debounce;

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<PosCubit>().searchProducts(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // حقل البحث مع Debounce
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: LanguageKeys.searchProductHint,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ),

        Expanded(
          child: BlocBuilder<PosCubit, PosState>(
            buildWhen: (previous, current) {
              if (previous is PosLoaded && current is PosLoaded) {
                return previous.products != current.products;
              }
              return previous.runtimeType != current.runtimeType;
            },
            builder: (context, state) {
              if (state is PosLoadingProducts) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PosError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              }

              if (state is PosLoaded) {
                final products = state.products;

                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      LanguageKeys.noProductsFound,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  cacheExtent: 300,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 0.82,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: POSProductCard(
                        key: ValueKey(product.id),
                        product: product,
                        onTap: product.stock > 0
                            ? () => context.read<PosCubit>().addToCart(product)
                            : null,
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
