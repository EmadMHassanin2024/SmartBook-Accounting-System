import 'package:smart_book/features/inventory/auth_exports.dart';
import '../../settings/logic/SettingsCubit.dart';
import '../../system_config/logic/system_configuration_state.dart';
import '../../../core/utils/extensions/localization_extension.dart';
import '../widgets/inventory_state_views.dart';

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
      final systemConfigCubit =
      context.read<SystemConfigurationCubit>();

      final inventoryCubit =
      context.read<InventoryCubit>();

      final activeModule =
          systemConfigCubit.state.settings.activeBusinessModule;

      inventoryCubit.changeActivityType(activeModule);
      inventoryCubit.fetchProducts();
    });
  }

  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 320;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leadingWidth: isCompact ? 56 : 96,
        leading: isCompact
            ? null
            : BlocBuilder<SettingsCubit, Locale>(
          builder: (context, locale) {
            final String nextLanguage =
            locale.languageCode == 'ar' ? 'EN' : 'AR';

            return InkWell(
              onTap: () =>
                  context.read<SettingsCubit>().toggleLanguage(),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.language,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    nextLanguage,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        title: Text(
          context.lang.itemsAndInventory,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
            listenWhen: (previous, current) =>
            previous.settings.activeBusinessModule !=
                current.settings.activeBusinessModule,
            listener: (context, state) {
              final inventoryCubit = context.read<InventoryCubit>();
              inventoryCubit.changeActivityType(
                state.settings.activeBusinessModule,
              );

              inventoryCubit.fetchProducts();

            },
          ),
          BlocListener<AdjustmentCubit, AdjustmentState>(
            listenWhen: (previous, current) =>
            current is AdjustmentSuccess,
            listener: (context, state) {
              if (state is AdjustmentSuccess) {
                context.read<InventoryCubit>().fetchProducts();
              }
            },
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

  void _openFilters(BuildContext context) {
    final inventoryCubit = context.read<InventoryCubit>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return InventoryFilterSheet(
          onFilterSelected: (category) {
            inventoryCubit.filterByCategory(category);
          },
        );
      },
    );
  }
}