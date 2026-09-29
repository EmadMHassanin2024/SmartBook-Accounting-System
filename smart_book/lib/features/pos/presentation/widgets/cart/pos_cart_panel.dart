import 'package:smart_book/features/pos/auth_exports.dart';
import '../../../../../core/localization/language_keys.dart';

class POSDesktopCartPanel extends StatelessWidget {
  const POSDesktopCartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      buildWhen: _shouldRebuild,
      builder: (context, state) {
        if (state is PosInitial || state is PosLoadingProducts) {
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
          final cartItems = state.cartItems;
          final activeExtension = state.extension;

          return Column(
            children: [
              // عنوان الفاتورة
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  LanguageKeys.newInvoice,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              // أزرار الـ extension
              if (activeExtension != null && cartItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: activeExtension.buildCartExtraActions(
                      cartItems.first,
                    ),
                  ),
                ),

              // قائمة السلة
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(
                  child: Text(
                    LanguageKeys.emptyCart,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return POSCartItem(
                      key: ValueKey(item.product.id),
                      item: item,
                    );
                  },
                ),
              ),

              // ملخص السلة
              POSCartSummarySection(state: state),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// ------------------------------------------------------
///                BUILD WHEN (REBUILD LOGIC)
/// ------------------------------------------------------

bool _shouldRebuild(PosState previous, PosState current) {
  // إذا تغير نوع الحالة (Initial → Loaded أو Loaded → Error)
  if (previous.runtimeType != current.runtimeType) return true;

  // مقارنة دقيقة لحالة Loaded فقط
  if (previous is PosLoaded && current is PosLoaded) {
    // إذا تغير الـ extension
    if (previous.extension != current.extension) return true;

    // إذا تغير عدد عناصر السلة
    if (previous.cartItems.length != current.cartItems.length) return true;

    // مقارنة دقيقة لكل عنصر في السلة
    for (int i = 0; i < previous.cartItems.length; i++) {
      final oldItem = previous.cartItems[i];
      final newItem = current.cartItems[i];

      // تغيّر الكمية أو تغيّر المنتج نفسه
      if (oldItem.quantity != newItem.quantity ||
          oldItem.product.id != newItem.product.id) {
        return true;
      }
    }
  }

  return false;
}