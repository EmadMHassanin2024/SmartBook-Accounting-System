import 'package:flutter/material.dart';
import 'package:smart_book/features/pos/presentation/widgets/cart/pos_cart_item.dart';
import 'package:smart_book/features/pos/presentation/widgets/summary/pos_cart_summary_section.dart';
import '../../../../../core/localization/language_keys.dart';
import '../../../logic/PosState.dart';

class POSLoadedView extends StatelessWidget {
  final PosLoaded state;

  const POSLoadedView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cartItems = state.cartItems;

    if (cartItems.isEmpty) {
      return const Center(
        child: Text(
          LanguageKeys.emptyCartMessage,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            cacheExtent: 300, // تحسين الأداء عند السلة الكبيرة
            itemBuilder: (context, index) {
              final item = cartItems[index];

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: POSCartItem(
                  key: ValueKey(item.product.id),
                  item: item,
                ),
              );
            },
          ),
        ),

        POSCartSummarySection(state: state),
      ],
    );
  }
}
