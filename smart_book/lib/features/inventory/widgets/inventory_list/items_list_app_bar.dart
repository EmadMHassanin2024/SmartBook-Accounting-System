import 'package:smart_book/features/inventory/auth_exports.dart';

import '../common/inventory_language_button.dart';
//AppBar
class ItemsListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onFilterPressed;

  const ItemsListAppBar({
    super.key,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 96,
      leading: const InventoryLanguageButton(),
      title: Text(
        context.lang.itemsAndInventory,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: onFilterPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}