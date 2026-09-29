import 'package:flutter/material.dart';
import '../../../data/models/cart_item_model.dart';
import 'pos_item_info.dart';
import 'pos_item_quantity_controls.dart';
import 'pos_item_subtotal.dart';

class POSCartItem extends StatelessWidget {
  final CartItemModel item;

  const POSCartItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: POSItemInfo(item: item),
          ),
          Expanded(
            flex: 2,
            child: POSItemQuantityControls(item: item),
          ),
          Expanded(
            flex: 2,
            child: POSItemSubtotal(item: item),
          ),
        ],
      ),
    );
  }
}