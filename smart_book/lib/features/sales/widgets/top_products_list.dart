
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TopProductsList extends StatelessWidget {
  const TopProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          _productItem("آيفون 15 برو", "120 قطعة", "450,000 ر.س"),
          const Divider(height: 1),
          _productItem("شاحن سريع 20 وات", "85 قطعة", "12,000 ر.س"),
        ],
      ),
    );
  }

  Widget _productItem(String name, String qty, String total) {
    return ListTile(
      title: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      subtitle: Text("الكمية المباعة: $qty", style: const TextStyle(fontSize: 11)),
      trailing: Text(total, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
    );
  }
}