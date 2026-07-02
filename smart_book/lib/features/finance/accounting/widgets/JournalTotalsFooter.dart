

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';



// المكون الثالث: شريط تذييل المجاميع والاتزان (معدل)
class JournalTotalsFooter extends StatelessWidget {
  final double debit;
  final double credit;
  final bool isBalanced;

  const JournalTotalsFooter({super.key, required this.debit, required this.credit, required this.isBalanced});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildAmountBox("المدين", debit, Colors.green)),
          const SizedBox(width: 5),
          Expanded(child: _buildAmountBox("الدائن", credit, Colors.red)),
          const SizedBox(width: 5),
          Icon(
            isBalanced ? Icons.check_circle : Icons.error_outline,
            color: isBalanced ? Colors.green : Colors.orange,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountBox(String title, double val, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(val.toStringAsFixed(2), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}