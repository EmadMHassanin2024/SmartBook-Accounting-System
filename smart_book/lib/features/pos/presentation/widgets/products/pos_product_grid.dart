import 'package:smart_book/core/localization/language_keys.dart';
import 'package:smart_book/features/pos/auth_exports.dart';
import 'package:smart_book/features/pos/presentation/widgets/products/pos_product_card.dart';

class POSProductGrid extends StatelessWidget {
  const POSProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // حقل البحث يرسل مباشرة للكيوبت الذي يتولى الـ Debounce
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
            onChanged: (query) {
              context.read<PosCubit>().searchProducts(query);
            },
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