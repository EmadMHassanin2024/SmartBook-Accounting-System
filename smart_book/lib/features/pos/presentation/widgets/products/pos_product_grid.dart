
import 'package:smart_book/features/pos/auth_exports.dart';
import 'package:smart_book/features/pos/presentation/widgets/products/pos_product_card.dart';

class POSProductGrid extends StatefulWidget {
  const POSProductGrid({super.key});

  @override
  State<POSProductGrid> createState() => _POSProductGridState();
}

class _POSProductGridState extends State<POSProductGrid> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        if (state is PosLoadingProducts) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PosError) {
          return Center(child: Text(state.message));
        }
        if (state is PosLoaded) {
          final activeExtension = context.read<PosCubit>().activeExtension;
          String currentActivityType = 'general';

          if (activeExtension != null) {
            final extensionName = activeExtension.runtimeType.toString().toLowerCase();
            if (extensionName.contains('pharmacy')) {
              currentActivityType = 'pharmacy';
            } else if (extensionName.contains('restaurant')) {
              currentActivityType  = 'restaurant';
            }
          }

          // 1. تصفية المنتجات بناءً على النشاط والبحث معاً
          final filteredProducts = state.products.where((product) {
            final matchesExtension = currentActivityType == 'general' ||
                product.itemType == currentActivityType;

            final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());

            return matchesExtension && matchesSearch;
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
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              ),
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(child: Text("لا توجد منتجات مطابقة للبحث أو القسم"))
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
                      onTap: product.stock > 0
                          ? () => context.read<PosCubit>().addToCart(product)
                          : null,
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