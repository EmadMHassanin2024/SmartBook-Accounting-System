import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryStatsSection extends StatelessWidget {
  const InventoryStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCubit, InventoryState>(
      buildWhen: (previous, current) {

        return current is InventoryLoaded || current is InventoryLoading;
      },
      builder: (context, state) {
        if (state is InventoryLoading) {
          return const QuickStatsWidget(
            totalCount: 0,
            lowStockCount: 0,
            outOfStockCount: 0,
            onTotalTap: null,
            onLowStockTap: null,
            onOutOfStockTap: null,
          );
        }
        if (state is InventoryLoaded) {
          final cubit = context.read<InventoryCubit>();
          return QuickStatsWidget(
            totalCount: state.totalCount,
            lowStockCount: state.lowStockCount,
            outOfStockCount: state.outOfStockCount,
            onTotalTap: () => cubit.filterByCategory(LanguageKeys.allCategoryKey),
            onLowStockTap: () => cubit.filterByCategory(LanguageKeys.lowStockCategoryKey),

            onOutOfStockTap: () => cubit.filterByCategory(LanguageKeys.outOfStockCategoryKey),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}