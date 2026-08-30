import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryContentView extends StatelessWidget {
  final InventoryLoaded state;
  final VoidCallback onOpenFilters;
  const InventoryContentView({super.key, required this.state, required this.onOpenFilters});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InventoryCubit>();
    return Expanded(
      child: Column(
        children: [
          InventorySearchBar(
            onChanged: (value) => cubit.filterProducts(value),
            onFilterTap: onOpenFilters,
          ),
          Expanded(child: InventoryListView(state: state)),
        ],
      ),
    );
  }
}