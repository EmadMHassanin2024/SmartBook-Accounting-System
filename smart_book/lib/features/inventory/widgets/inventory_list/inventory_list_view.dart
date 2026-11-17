import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryListView extends StatelessWidget {
  final InventoryState state;

  const InventoryListView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is InventoryLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is InventoryError) {
      final errorState = state as InventoryError;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text(
              errorState.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => context.read<InventoryCubit>().fetchProducts(),
              icon: const Icon(Icons.refresh),
              label: const AppText(textKey: LanguageKeys.retryKey), // أو Text("إعادة المحاولة")
            ),
          ],
        ),
      );
    }

    if (state is InventoryLoaded) {
      final loadedState = state as InventoryLoaded;

      if (loadedState.products.isEmpty) {
        return const Center(
          child: AppText(
            textKey: LanguageKeys.noItemsMatchSelectionKey,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
        itemCount: loadedState.products.length,
        itemBuilder: (context, index) {
          final product = loadedState.products[index];
          return ItemCardWidget(product: product);
        },
      );
    }

    return const SizedBox.shrink();
  }
}