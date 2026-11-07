
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

      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarHelper.showError(

          (state as InventoryError).message,
        );
      });
      return const Center(child: Text(LanguageKeys.errorOccurredKey));

    }

    if (state is InventoryLoaded) {
      final loadedState = state as InventoryLoaded;
      if (loadedState.products.isEmpty) {
        return const Center(
          child: Text(
            LanguageKeys.noItemsMatchSelectionKey,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
        itemCount: loadedState.products.length,
        itemBuilder: (context, index) {
          final product = loadedState.products[index];

          return ItemCardWidget(
            product: product,
            // هنا قمنا بربط الزر بفتح شاشة الجرد
            onAdjustmentPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<AdjustmentCubit>(),
                    child: InventoryAdjustmentScreen(product: product),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}