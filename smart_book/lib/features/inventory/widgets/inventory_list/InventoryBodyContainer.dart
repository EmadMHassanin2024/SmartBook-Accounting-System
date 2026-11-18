
import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryBodyContainer extends StatelessWidget {
  const InventoryBodyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryCubit, InventoryState>(
      listenWhen: (previous, current) =>
      current is InventoryActivityChanged ||
          current is InventoryError ||
          current is DeleteProductSuccess ||
          current is DeleteProductError,
      listener: (context, state) {
        if (state is InventoryActivityChanged) {
          context.read<InventoryCubit>().fetchProducts();
        } else if (state case InventoryError(:final message)) {
          SnackbarHelper.showError(message);
        } else if (state case DeleteProductSuccess(:final message)) {
          SnackbarHelper.showSuccess(message);
        } else if (state case DeleteProductError(:final error)) {
          SnackbarHelper.showError(error);
        }
      },
      child: InventoryStateViews(
        onOpenFilters: () =>
            InventoryNavigationHelper.openFilterSheet(context),
      ),
    );
  }
}