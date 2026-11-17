import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryStateViews extends StatelessWidget {
  final VoidCallback onOpenFilters;

  const InventoryStateViews({
    super.key,
    required this.onOpenFilters,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InventoryCubit>();

    return BlocBuilder<InventoryCubit, InventoryState>(
      buildWhen: (previous, current) {
        return current is InventoryLoading ||
            current is InventoryLoaded ||
            current is InventoryError;
      },
      builder: (context, state) {
        if (state is InventoryLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryBlue,
            ),
          );
        }

        if (state is InventoryError) {
          return const Center(
            child: AppText(
            textKey: LanguageKeys.errorKey,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),

            ),
          );
        }

        if (state is InventoryLoaded) {
          return Column(
            children: [
              // 1. قسم الإحصائيات ثابت بالأعلى
              const InventoryStatsSection(),
              const SizedBox(height: 8),

              // 2. شريط البحث يظل ظاهراً وثابتاً دائماً لا يختفي أبداً
              InventorySearchBar(
                onChanged: (value) => cubit.filterProducts(value),
                onFilterTap: onOpenFilters,
              ),

              // 3. الجزء السفلي: إذا كانت المنتجات فارغة نعرض الرسالة في المنتصف، وإلا نعرض القائمة
              Expanded(
                child: state.products.isEmpty
                    ? const Center(
                  child: AppText(
                    textKey: LanguageKeys.noItemsMatchSelectionKey,
                  ),
                )
                    : InventoryListView(state: state),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}