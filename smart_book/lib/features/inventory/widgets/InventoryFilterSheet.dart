import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions/localization_extension.dart';

class InventoryFilterSheet extends StatelessWidget {
  final Function(String) onFilterSelected;

  const InventoryFilterSheet({super.key, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              context.lang.filterByInventoryStatus,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 5),
          _filterOption(context, context.lang.all, Icons.inventory_2_outlined, AppColors.primaryBlue),
          _filterOption(context, context.lang.lowStock, Icons.warning_amber_rounded, Colors.orange),
          _filterOption(context, context.lang.outOfStock, Icons.error_outline, Colors.red),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _filterOption(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
        onTap: () {
          onFilterSelected(title);
          Navigator.pop(context);
        },
      ),
    );
  }
}