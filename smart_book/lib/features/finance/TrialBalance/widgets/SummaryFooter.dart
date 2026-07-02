// ويدجت الفوتر المحدث
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../models/TrialBalanceItem.dart';
import 'SummaryItem.dart';

class SummaryFooter extends StatelessWidget {
  final List<TrialBalanceItem> items;
  const SummaryFooter({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final tD = items.fold(0.0, (s, i) => s + i.totalDebit);
    final tC = items.fold(0.0, (s, i) => s + i.totalCredit);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // خلفية خفيفة مميزة للفوتر
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SummaryItem(title: lang.totalDebit, value: tD.toStringAsFixed(2), color: Colors.green.shade700),
          SummaryItem(title: lang.totalCredit, value: tC.toStringAsFixed(2), color: Colors.red.shade700),
        ],
      ),
    );
  }
}