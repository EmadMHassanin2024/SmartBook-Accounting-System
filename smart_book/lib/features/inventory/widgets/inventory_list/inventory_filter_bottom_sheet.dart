import 'package:smart_book/features/inventory/auth_exports.dart';



class InventoryFilterHelper {
  static void show(BuildContext context, {required Function(String) onFilterSelected}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return InventoryFilterSheet(
          onFilterSelected: onFilterSelected,
        );
      },
    );
  }
}