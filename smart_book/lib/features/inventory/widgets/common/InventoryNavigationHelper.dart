
import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryNavigationHelper {
  static void openFilterSheet(BuildContext context) {
    InventoryFilterHelper.show(
      context,
      onFilterSelected: (category) {
        if (context.mounted) {
          context.read<InventoryCubit>().filterByCategory(category);
        }
      },
    );
  }
}