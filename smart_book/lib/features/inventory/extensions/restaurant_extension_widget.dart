import 'package:flutter/material.dart';

class RestaurantExtensionWidget extends StatelessWidget {
  final bool isIngredient;
  final ValueChanged<bool?> onIsIngredientChanged;

  const RestaurantExtensionWidget({
    super.key,
    required this.isIngredient,
    required this.onIsIngredientChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "خصائص المطعم والمطبخ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          CheckboxListTile(
            title: const Text("هل هذا الصنف مادة خام (تُخصم من المخزن بناءً على الوصفات)؟"),
            value: isIngredient,
            onChanged: onIsIngredientChanged,
            activeColor: Colors.orange,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}