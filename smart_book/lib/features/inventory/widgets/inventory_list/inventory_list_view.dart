import '../../../../core/localization/language_keys.dart';
import '../../../../core/packages.dart';
import '../../../../core/widgets/app_text.dart';
import '../../logic/InventoryCubit.dart';
import '../../logic/InventoryState.dart';
import 'item_card_widget.dart';

class InventoryListView extends StatelessWidget {
  const InventoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCubit, InventoryState>(
      buildWhen: (previous, current) =>
      current is InventoryLoading ||
          current is InventoryLoaded ||
          current is InventoryError,
      builder: (context, state) {
        if (state is InventoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is InventoryError) {
          return Center(
            child: ElevatedButton.icon(
              onPressed: () => context.read<InventoryCubit>().fetchProducts(),
              icon: const Icon(Icons.refresh),
              label: const AppText(textKey: LanguageKeys.retryKey),
            ),
          );
        }

        if (state case InventoryLoaded(:final products)) {
          if (products.isEmpty) {
            return const Center(
              child: AppText(
                textKey: LanguageKeys.noItemsMatchSelectionKey,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<InventoryCubit>().fetchProducts(),
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  ItemCardWidget(
                key: ValueKey(products[index].id),
                product: products[index],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}