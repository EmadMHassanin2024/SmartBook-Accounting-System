import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';

class PharmacyProductDetails extends StatelessWidget {
  final ProductModel product;

  const PharmacyProductDetails({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          const Divider(height: 8),

          PharmacyInfoRow(
            icon: Icons.inventory_2_outlined,
            title: "Batch",
            value: "B-20260015",
          ),

          const SizedBox(height: 4),

          PharmacyInfoRow(
            icon: Icons.event,
            title: "Expiry",
            value: "30/12/2027",
            valueColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

class PharmacyInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  const PharmacyInfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Icon(
          icon,
          size: 12,
          color: Colors.grey,
        ),

        const SizedBox(width: 4),

        Text(
          "$title:",
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(width: 4),

        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 10,
              color: valueColor ?? Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}