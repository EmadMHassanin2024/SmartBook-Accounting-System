import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

class AddProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEditing;
  final String addProductTitleKey; //

  final List<Widget>? actions;

  const AddProductAppBar({
    super.key,
    required this.isEditing,
  this.actions,
    required this.addProductTitleKey,
  });

  @override
  Widget build(BuildContext context) {
    final String titleText = isEditing ? "تعديل صنف" : context.translate(addProductTitleKey);
    return AppBar(
      actions: actions,
      title: Text(
        titleText,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}