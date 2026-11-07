import 'package:smart_book/core/widgets/app_text.dart';
import 'package:smart_book/features/inventory/auth_exports.dart';
import '../common/inventory_stats_section.dart';
import 'inventory_content_view.dart';

class InventoryStateViews extends StatelessWidget {
  final InventoryState state;
  final VoidCallback onOpenFilters;

  const InventoryStateViews({
    super.key,
    required this.state,
    required this.onOpenFilters,
  });

  @override
  Widget build(BuildContext context) {
    if (state is InventoryLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryBlue,
        ),
      );
    }
    if (state is InventoryError) {
      final errorState = state as InventoryError;
      return Center(
        child: Text(
          'خطأ: ${errorState.message.replaceAll("Exception: ", "")}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }


    if (state is InventoryLoaded) {
      final loadedState = state as InventoryLoaded;

      if (loadedState.products.isEmpty) {
        return const Center(
          child:AppText(
            textKey: LanguageKeys.noItemsMatchSelectionKey,
          ),
        );
      }

      return Column(
        children: [
          InventoryStatsSection(
            state: loadedState,
          ),
          Expanded(
            child: InventoryContentView(
              state: loadedState,
              onOpenFilters: onOpenFilters,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}