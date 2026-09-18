
import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryNavigationHelper {
  static void openFilterSheet(BuildContext context) {
    InventoryFilterHelper.show(
      context,
      onFilterSelected: (category) {
        context.read<InventoryCubit>().filterByCategory(category);
      },
    );
  }
}