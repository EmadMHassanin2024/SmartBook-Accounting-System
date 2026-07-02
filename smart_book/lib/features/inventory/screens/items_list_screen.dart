import 'package:smart_book/features/inventory/auth_exports.dart';
import '../../../core/di/service_locator.dart';
import '../../finance/adjustments/logic/adjustment_cubit.dart';
import '../../finance/adjustments/logic/adjustment_state.dart';


// هذه الشاشة هي "لوحة التحكم" للمخزن، وتعتمد على InventoryCubit النظيف ومحقون العلاقات
class ItemsListScreen extends StatelessWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // 🚀 استخدام GetIt لحقن الـ Cubit مع خدماته بشكل مستقل وتلقائي
      create: (context) => sl<InventoryCubit>()..fetchProducts(),
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
        body:BlocListener<AdjustmentCubit, AdjustmentState>(
          listener: (context, state) {
            if (state is AdjustmentSuccess) {
              // هنا السر: بمجرد نجاح الجرد، نطلب من InventoryCubit تحديث البيانات
              context.read<InventoryCubit>().fetchProducts();
            }
          },
          child: BlocBuilder<InventoryCubit, InventoryState>(
            builder: (context, state) {
              // 1. معالجة حالة التحميل
              if (state is InventoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2. معالجة حالة الخطأ
              if (state is InventoryError) {
                return Center(child: Text("حدث خطأ: ${state.message}"));
              }

              // 3. الحالة الطبيعية (Loaded)
              return Column(

                children: [
                  QuickStatsWidget(
                    totalCount: state is InventoryLoaded ? state.totalCount : 0,
                    lowStockCount: state is InventoryLoaded ? state.lowStockCount : 0,
                    outOfStockCount: state is InventoryLoaded ? state.outOfStockCount : 0,
                    onTotalTap: () => context.read<InventoryCubit>().filterByCategory("الكل"),
                    onLowStockTap: () => context.read<InventoryCubit>().filterByCategory("قربت تنتهي"),
                    onOutOfStockTap: () => context.read<InventoryCubit>().filterByCategory("منتهية"),
                  ),
                  InventorySearchBar(
                    onChanged: (val) => context.read<InventoryCubit>().filterProducts(val),
                    onFilterTap: () => _openFilters(context),
                  ),
                  Expanded(child: InventoryListView(state: state)),
                ],

              );

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
      builder: (ctx) => InventoryFilterSheet(
        // نمرر الـ context الأصلي الذي يحتوي على الـ Bloc
        onFilterSelected: (category) => context.read<InventoryCubit>().filterByCategory(category),
      ),
    );
  }
}