
import 'package:flutter/material.dart';

class InventoryFilterSheet extends StatelessWidget {
  final Function(String) onFilterSelected;

  const InventoryFilterSheet({super.key, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("تصفية حسب حالة المخزون",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const Divider(),
          _filterOption(context, "الكل", Icons.inventory_2, Colors.blue),
          _filterOption(context, "منتهية", Icons.error_outline, Colors.red),
          _filterOption(context, "قربت تنتهي", Icons.warning_amber_rounded, Colors.orange),
        ],
      ),
    );
  }

  Widget _filterOption(BuildContext context, String title, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: () {
        onFilterSelected(title);
        Navigator.pop(context);
      },
    );
  }
}