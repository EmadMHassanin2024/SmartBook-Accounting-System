
import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryExtensionManager {
  static Widget getExtensionWidget({
    String? activityType,
    // بارامترات الصيدلية
    required TextEditingController expiryController,
    required TextEditingController batchController,
    required VoidCallback onSelectExpiry,
    // بارامترات المطعم 💡
     bool ? isIngredient,
  ValueChanged<bool?>? onIsIngredientChanged,
  }) {
    switch (activityType) {
      case 'pharmacy':
        return PharmacyExtensionWidget(
          expiryController: expiryController ?? TextEditingController(),
          batchController: batchController ?? TextEditingController(),
          onSelectExpiry: onSelectExpiry ?? () {},
        );

      case 'restaurant':
        return RestaurantExtensionWidget(
          isIngredient: isIngredient ?? false,
          onIsIngredientChanged: onIsIngredientChanged ?? (_) {},
        );

      case 'clothing':
        return const SizedBox.shrink();

      default:
        return const SizedBox.shrink();
    }
  }
}