import 'package:smart_book/features/inventory/auth_exports.dart';

import '../../../../core/widgets/app_text.dart';

class ItemsListAppBar extends StatelessWidget implements PreferredSizeWidget {

  const ItemsListAppBar({
    super.key,

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

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}