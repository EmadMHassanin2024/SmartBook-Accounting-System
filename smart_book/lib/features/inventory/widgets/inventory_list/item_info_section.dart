import 'package:smart_book/features/inventory/auth_exports.dart';

class ItemInfoSection extends StatelessWidget {
  final ProductModel product;

  const ItemInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primaryBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                DefaultTextStyle(
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: Row(
                    children: [
                      const AppText(textKey: LanguageKeys.barcodeKey),
                      const Text(": "),
                      Flexible(
                        child: product.barcode.isEmpty
                            ? const AppText(textKey: LanguageKeys.noBarcodeKey)
                            : Text(product.barcode),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}