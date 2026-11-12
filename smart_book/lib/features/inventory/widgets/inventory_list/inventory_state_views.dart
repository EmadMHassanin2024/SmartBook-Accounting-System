import 'package:smart_book/core/widgets/app_text.dart';
import 'package:smart_book/features/inventory/auth_exports.dart';
import '../common/inventory_stats_section.dart';
import 'inventory_content_view.dart';

class InventoryStateViews extends StatelessWidget {

  final VoidCallback onOpenFilters;

  const InventoryStateViews({
    super.key,
    required this.onOpenFilters,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
        children: [
        const InventoryStatsSection(),

    Expanded(
   child:  BlocBuilder<InventoryCubit, InventoryState>(
        builder: (context, state)
    {
      if (state is InventoryLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBlue,
          ),
        );
      }
      if (state is InventoryError) {
        final errorState = state;
        return Center(
          child: Text(
            'خطأ: ${errorState.message.replaceAll("Exception: ", "")}',
            style: const TextStyle(color: Colors.red),
          ),
        );
      }


      if (state is InventoryLoaded) {
        final loadedState = state;

        if (loadedState.products.isEmpty) {
          return const Center(
            child: AppText(
              textKey: LanguageKeys.noItemsMatchSelectionKey,
            ),
          );
        }

        return  InventoryContentView(
                state: loadedState,
                onOpenFilters: onOpenFilters,

        );
      }

      return const SizedBox.shrink();
    },
   ),
    ),
        ],
    );
  }
}