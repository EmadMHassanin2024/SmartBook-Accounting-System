import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryStatsSection extends StatelessWidget {
  const InventoryStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCubit, InventoryState>(
      builder: (context, state) {

        if (state is InventoryLoaded) {
          final cubit = context.read<InventoryCubit>();
          return QuickStatsWidget(
            totalCount: state.totalCount,
            lowStockCount: state.lowStockCount,
            outOfStockCount: state.outOfStockCount,
            onTotalTap: () => cubit.filterByCategory(LanguageKeys.allCategoryKey),
            onLowStockTap: () => cubit.filterByCategory(LanguageKeys.lowStockCategoryKey),
            onOutOfStockTap: () => cubit.filterByCategory(LanguageKeys.expiredCategoryKey),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}