import 'package:smart_book/features/inventory/auth_exports.dart';
import '../../system_config/logic/system_configuration_state.dart';
import '../widgets/inventory_content_view.dart';
import '../widgets/inventory_stats_section.dart';


class ItemsListScreen extends StatefulWidget {
  const ItemsListScreen({super.key});

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  late final InventoryCubit _inventoryCubit;

  @override
  void initState() {
    super.initState();
    _inventoryCubit = sl<InventoryCubit>();
    final activeModule = context.read<SystemConfigurationCubit>().state.settings.activeBusinessModule;
    _inventoryCubit.changeActivityType(activeModule);
    _inventoryCubit.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _inventoryCubit,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          title: const Text("الأصناف والمستودع"),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _openFilters(context),
            ),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<SystemConfigurationCubit, SystemConfigurationState>(
              listenWhen: (prev, curr) => prev.settings.activeBusinessModule != curr.settings.activeBusinessModule,
              listener: (context, state) => _inventoryCubit.changeActivityType(state.settings.activeBusinessModule),
            ),
            BlocListener<AdjustmentCubit, AdjustmentState>(
              listener: (context, state) {
                if (state is AdjustmentSuccess) _inventoryCubit.fetchProducts();
              },
            ),
          ],
          child: BlocBuilder<InventoryCubit, InventoryState>(
            builder: (context, state) {
              if (state is InventoryLoading) return const Center(child: CircularProgressIndicator());
              if (state is InventoryError) return Center(child: Text("حدث خطأ: ${state.message}"));
              if (state is InventoryLoaded) {
                return Column(
                  children: [
                    InventoryStatsSection(state: state),
                    InventoryContentView(state: state, onOpenFilters: () => _openFilters(context)),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: const AddProductFAB(),
      ),
    );
  }

  void _openFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => InventoryFilterSheet(
        onFilterSelected: (category) => _inventoryCubit.filterByCategory(category),
      ),
    );
  }
}