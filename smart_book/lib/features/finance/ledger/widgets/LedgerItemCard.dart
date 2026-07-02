import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../models/ledger_transaction_model.dart';

class LedgerItemCard extends StatelessWidget {
  final LedgerTransaction transaction;

  const LedgerItemCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final lang = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    // معالجة الـ null هنا
                    transaction.contraAccountName.isEmpty ? lang.noContraAccount : transaction.contraAccountName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text("#${transaction.entryId}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfo(lang.dateLabel, transaction.date.toString().substring(0, 10)),
                const Spacer(),
                _buildAmount(lang.debitLabel, transaction.debit, Colors.green),
                const SizedBox(width: 16),
                _buildAmount(lang.creditLabel, transaction.credit, Colors.red),
                const SizedBox(width: 16),
                _buildAmount(lang.balanceLabel, transaction.runningBalance, primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildAmount(String label, double value, Color color) {
    if (value == 0) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
            value.toStringAsFixed(2),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)
        ),
      ],
    );
  }
}