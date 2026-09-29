import 'package:flutter/material.dart';
import '../../../data/models/cart_item_model.dart';

class POSItemInfo extends StatelessWidget {
  final CartItemModel item;

  const POSItemInfo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.product.name ?? "منتج بدون اسم",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          "${(item.product.price ?? 0.0).toStringAsFixed(2)} ر.س",
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}