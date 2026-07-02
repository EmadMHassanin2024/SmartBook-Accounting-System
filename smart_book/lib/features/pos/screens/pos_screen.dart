
import 'package:smart_book/features/auth/auth_exports.dart';
import 'package:smart_book/features/pos/auth_exports.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PosCubit>().fetchInventoryProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية رمادية فاتحة لتعطي تباينًا احترافيًا
      backgroundColor: Colors.grey.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // الشاشات الكبيرة (أكبر من 800 بكسل)
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                // 1. قسم المنتجات (60% من الشاشة)
                Expanded(
                  flex: 3,
                  child: _buildProductGrid(),
                ),
                // 2. قسم الفاتورة الثابت (40% من الشاشة)
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(left: BorderSide(color: Colors.grey, width: 0.2)),
                    ),
                    child: _buildDesktopCartPanel(),
                  ),
                ),
              ],
            );
          }

          // الشاشات الصغيرة (موبايل/تابلت) - العرض الأصلي
          return Stack(
            children: [
              _buildProductGrid(),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: _buildFloatingCartBar(context),
              ),
            ],
          );
        },
      ),
    );
  }

  // مصفوفة المنتجات (معدلة لتكون متجاوبة)
  Widget _buildProductGrid() {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        if (state is PosLoadingProducts) return const Center(child: CircularProgressIndicator());
        if (state is PosError) return Center(child: Text(state.message));
        if (state is PosLoaded) {
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220, // الكرت لن يتجاوز 220 بكسل عرضاً
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
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // واجهة السلة الثابتة للكمبيوتر (بدون الانتقال لشاشة أخرى)
  Widget _buildDesktopCartPanel() {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        if (state is PosLoaded) {
          return Column(
            children: [
              Container(padding: const EdgeInsets.all(16), child: const Text("فاتورة جديدة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              Expanded(
                child: state.cartItems.isEmpty
                    ? const Center(child: Text("السلة فارغة"))
                    : ListView.builder(
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) => POSCartItem(item: state.cartItems[index]),
                ),
              ),
              POSCartSummarySection(state: state),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // الـ Floating Bar للموبايل فقط
  Widget _buildFloatingCartBar(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        if (state is PosLoaded && state.cartItems.isNotEmpty) {
          return Container(
            height: 60,
            decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              title: Text("${state.totalAmount.toStringAsFixed(2)} ر.س", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.shopping_cart, color: Colors.white),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const POSCartDetailsScreen())),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}