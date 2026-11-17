import 'package:smart_book/features/inventory/auth_exports.dart';
import 'item_actions_section.dart';
import 'item_info_section.dart';

class ItemCardWidget extends StatelessWidget {
  final ProductModel product;

  const ItemCardWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ItemInfoSection(product: product),
          const SizedBox(width: 8),
          ItemActionsSection(product: product),
        ],
      ),
    );
  }
}