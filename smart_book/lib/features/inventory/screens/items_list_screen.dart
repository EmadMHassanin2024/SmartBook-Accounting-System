import 'package:smart_book/features/inventory/auth_exports.dart';


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
      _initializeInventoryData();
    });
  }

  void _initializeInventoryData() {
    final systemConfigCubit = context.read<SystemConfigurationCubit>();
    final inventoryCubit = context.read<InventoryCubit>();
    final activeModule = systemConfigCubit.state.settings.activeBusinessModule;

    inventoryCubit.changeActivityType(activeModule);
    inventoryCubit.fetchProducts();
  }

  void _onSystemConfigChanged(BuildContext context, SystemConfigurationState state) {
    final inventoryCubit = context.read<InventoryCubit>();
    inventoryCubit.changeActivityType(state.settings.activeBusinessModule);
    inventoryCubit.fetchProducts();
  }

  void _onAdjustmentSuccess(BuildContext context, AdjustmentState state) {
    if (state is AdjustmentSuccess) {
      context.read<InventoryCubit>().fetchProducts();
    }
  }

  void _openFilters(BuildContext context) {
    final inventoryCubit = context.read<InventoryCubit>();
    InventoryFilterHelper.show(
      context,
      onFilterSelected: (category) {
        inventoryCubit.filterByCategory(category);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: ItemsListAppBar(
        onFilterPressed: () => _openFilters(context),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SystemConfigurationCubit, SystemConfigurationState>(
            listenWhen: (previous, current) =>
            previous.settings.activeBusinessModule !=
                current.settings.activeBusinessModule,
            listener: _onSystemConfigChanged,
          ),
          BlocListener<AdjustmentCubit, AdjustmentState>(
            listenWhen: (previous, current) => current is AdjustmentSuccess,
            listener: _onAdjustmentSuccess,
          ),
        ],
        child: BlocBuilder<InventoryCubit, InventoryState>(
          buildWhen: (previous, current) {
            return current is InventoryLoading ||
                current is InventoryError ||
                current is InventoryLoaded;
          },
          builder: (context, state) {
            return InventoryStateViews(
              state: state,
              onOpenFilters: () => _openFilters(context),
            );
          },
        ),
      ),
      floatingActionButton: const AddProductFAB(),
    );
  }
}