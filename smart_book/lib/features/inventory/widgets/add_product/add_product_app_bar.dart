import 'package:flutter/material.dart';

class AddProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEditing;
  final String addProductTitle;

  const AddProductAppBar({
    super.key,
    required this.isEditing,
    required this.addProductTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        isEditing ? "تعديل صنف" : addProductTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}