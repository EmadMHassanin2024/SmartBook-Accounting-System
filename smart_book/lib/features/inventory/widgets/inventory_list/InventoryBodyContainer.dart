
import 'package:smart_book/features/inventory/auth_exports.dart';
class InventoryBodyContainer extends StatelessWidget {
  const InventoryBodyContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<InventoryCubit, InventoryState>(
      builder: (context, state) {
        return InventoryStateViews(

          onOpenFilters: () =>
              InventoryNavigationHelper.openFilterSheet(context),
        );
      },
    );
  }
}