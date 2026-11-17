import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryBodyContainer extends StatelessWidget {
  const InventoryBodyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryCubit, InventoryState>(
      listenWhen: (previous, current) {
        // الاستماع فقط عند تغير النشاط
        return current is InventoryActivityChanged;
      },
      listener: (context, state) {
        if (state is InventoryActivityChanged) {
          context.read<InventoryCubit>().fetchProducts();
        }
      },
      child: InventoryStateViews(
        onOpenFilters: () =>
            InventoryNavigationHelper.openFilterSheet(context),
      ),
    );
  }
}