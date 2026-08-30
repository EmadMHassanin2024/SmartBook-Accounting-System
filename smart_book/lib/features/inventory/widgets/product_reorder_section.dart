import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProductReorderSection extends StatelessWidget {
  final TextEditingController reorderLevelController;

  const ProductReorderSection({super.key, required this.reorderLevelController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_outlined, color: Colors.orange),
          const SizedBox(width: 12),
          const Expanded(child: Text("نبهني عند وصول الكمية إلى:")),
          SizedBox(
            width: 60,
            child: TextFormField(
              controller: reorderLevelController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(isDense: true),
            ),
          ),
        ],
      ),
    );
  }
}