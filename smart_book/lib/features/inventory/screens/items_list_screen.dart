import 'package:smart_book/features/inventory/auth_exports.dart';
import '../widgets/common/InventoryNavigationHelper.dart';

class ItemsListScreen extends StatefulWidget {
  const ItemsListScreen({super.key});

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<InventoryCubit>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}