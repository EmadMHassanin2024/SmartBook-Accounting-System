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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarHelper.showError(
          errorState.message,
        );
      });
      return Center(
        child: Text(
          context.lang.errorOccurred,
        ),
      );
    }

    if (state is InventoryLoaded) {
      final loadedState = state as InventoryLoaded;

      if (loadedState.products.isEmpty) {
        return Center(
          child: Text(
            context.lang.noItemsMatchSelection,
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