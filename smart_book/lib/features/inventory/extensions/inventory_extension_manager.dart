
import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryExtensionManager {
  static Widget getExtensionWidget({
    required String activityType,
    // بارامترات الصيدلية
    required TextEditingController expiryController,
    required TextEditingController batchController,
    required VoidCallback onSelectExpiry,
    // بارامترات المطعم 💡
    required bool isIngredient,
    required ValueChanged<bool?> onIsIngredientChanged,
  }) {
    switch (activityType) {
      case 'pharmacy':
        return PharmacyExtensionWidget(
          expiryController: expiryController,
          batchController: batchController,
          onSelectExpiry: onSelectExpiry,
        );

      case 'restaurant':
        return RestaurantExtensionWidget(
          isIngredient: isIngredient,
          onIsIngredientChanged: onIsIngredientChanged,
        );

      case 'clothing':
        return const SizedBox.shrink();

      default:
        return const SizedBox.shrink();
    }
  }
}