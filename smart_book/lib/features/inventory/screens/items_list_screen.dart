import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/features/inventory/auth_exports.dart';
import '../../../core/di/service_locator.dart';
import '../../finance/adjustments/logic/adjustment_cubit.dart';
import '../../finance/adjustments/logic/adjustment_state.dart';
import '../../system_config/data/models/ business_module.dart';
import '../../system_config/logic/system_configuration_cubit.dart';


class ItemsListScreen extends StatelessWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
        body: BlocListener<AdjustmentCubit, AdjustmentState>(
          listener: (context, state) {
            if (state is AdjustmentSuccess) {
              context.read<InventoryCubit>().fetchProducts();
            }
          },
          child: BlocBuilder<InventoryCubit, InventoryState>(
            builder: (context, state) {
              if (state is InventoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is InventoryError) {
                return Center(child: Text("حدث خطأ: ${state.message}"));
              }

              if (state is InventoryLoaded) {
                // 1. معرفة النشاط الحالي المفعل في النظام
                final settings = context.read<SystemConfigurationCubit>().state.settings;
                String currentActivityType = 'general'; // القيمة الافتراضية

                if (settings.hasBusinessModule(BusinessModule.pharmacy)) {
                  currentActivityType = 'pharmacy';
                } else if (settings.hasBusinessModule(BusinessModule.restaurant)) {
                  currentActivityType = 'restaurant';
                }

                // 🔍 طباعة تفكيكية لمعرفة البيانات
                print("--- [DEBUG INVENTORY] ---");
                print("Current Activity Type: $currentActivityType");
                print("Total products from API: ${state.products.length}");
                for (var p in state.products) {
                  print("Product: ${p.name} | itemType: '${p.itemType}' | stock: ${p.stock}");
                }
                // 2. تصفية صارمة ومستقلة: إظهار منتجات القسم النشط فقط
                final filteredProducts = state.products.where((product) {
                  return product.itemType == currentActivityType;
                }).toList();

                print("Filtered products count: ${filteredProducts.length}");
                print("--------------------------");
                return Column(
                  children: [
                    QuickStatsWidget(
                      totalCount: filteredProducts.length,
                      lowStockCount: filteredProducts.where((p) => p.stock <= 5).length,
                      outOfStockCount: filteredProducts.where((p) => p.stock == 0).length,
                      onTotalTap: () => context.read<InventoryCubit>().filterByCategory("الكل"),
                      onLowStockTap: () => context.read<InventoryCubit>().filterByCategory("قربت تنتهي"),
                      onOutOfStockTap: () => context.read<InventoryCubit>().filterByCategory("منتهية"),
                    ),
                    InventorySearchBar(
                      onChanged: (val) => context.read<InventoryCubit>().filterProducts(val),
                      onFilterTap: () => _openFilters(context),
                    ),
                    // 3. استخدام copyWith لتحديث القائمة المصفاة للقسم النشط فقط
                    Expanded(
                      child: InventoryListView(
                        state: state.copyWith(
                          products: filteredProducts,
                          totalCount: filteredProducts.length,
                          lowStockCount: filteredProducts.where((p) => p.stock <= 5).length,
                          outOfStockCount: filteredProducts.where((p) => p.stock == 0).length,
                        ),
                      ),
                    ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => InventoryFilterSheet(
        onFilterSelected: (category) => context.read<InventoryCubit>().filterByCategory(category),
      ),
    );
  }
}