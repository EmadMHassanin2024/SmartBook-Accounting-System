import 'package:smart_book/features/inventory/auth_exports.dart';
import '../widgets/common/InventoryNavigationHelper.dart';

class ItemsListScreen extends StatelessWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_)=>sl<InventoryCubit>()..initialize(),
      child: Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            appBar: ItemsListAppBar(
              onFilterPressed: () => InventoryNavigationHelper.openFilterSheet(context),
            ),
            body: BlocListener<AdjustmentCubit, AdjustmentState>(
              listenWhen: (previous, current) => current is AdjustmentSuccess,
              listener: (context, state) {
                context.read<InventoryCubit>().fetchProducts();
              },
              child: BlocConsumer<InventoryCubit, InventoryState>(
                listenWhen: (previous, current) => current is InventoryError,
                listener: (context, state) {
                  if (state is InventoryError) {
                    SnackbarHelper.showError(state.message);
                  }
                },
                builder: (context, state) {
                  return InventoryStateViews(
                    state: state,
                    onOpenFilters: () => InventoryNavigationHelper.openFilterSheet(context),
                  );
                },
              ),
            ),
            floatingActionButton: const AddProductFAB(),


      ),
    );
  }
}