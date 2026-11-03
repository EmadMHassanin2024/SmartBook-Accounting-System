
import 'package:smart_book/features/inventory/auth_exports.dart';
class InventoryBodyContainer extends StatelessWidget {
  const InventoryBodyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // الـ BlocBuilder هنا موجود في أعمق نقطة ممكنة، بحيث لا يعيد بناء الـ Scaffold أو الـ AppBar أبداً
    return BlocBuilder<InventoryCubit, InventoryState>(
      builder: (context, state) {
        return InventoryStateViews(
          state: state,
          onOpenFilters: () =>
              InventoryNavigationHelper.openFilterSheet(context),
        );
      },
    );
  }
}