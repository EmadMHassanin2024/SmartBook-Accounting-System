import 'package:smart_book/features/inventory/auth_exports.dart';

import '../../../../core/localization/language.dart';
import '../../../../core/widgets/app_text.dart';

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

      title: const AppText(
      textKey: LanguageKeys.appNameKey,
        style: TextStyle(
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