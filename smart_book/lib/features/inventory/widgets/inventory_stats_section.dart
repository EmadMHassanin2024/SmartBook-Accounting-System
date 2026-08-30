import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryStatsSection extends StatelessWidget {
  final InventoryLoaded state;
  const InventoryStatsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InventoryCubit>();
    return QuickStatsWidget(
      totalCount: state.totalCount,
      lowStockCount: state.lowStockCount,
      outOfStockCount: state.outOfStockCount,
      onTotalTap: () => cubit.filterByCategory("الكل"),
      onLowStockTap: () => cubit.filterByCategory("قربت تنتهي"),
      onOutOfStockTap: () => cubit.filterByCategory("منتهية"),
    );
  }
}