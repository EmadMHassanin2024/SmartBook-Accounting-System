// ويدجت الجدول المحدث
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../models/TrialBalanceItem.dart';

class TrialBalanceTable extends StatelessWidget {
  final List<TrialBalanceItem> items;
  const TrialBalanceTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Card( // إضافة Card لإعطاء شكل جمالي
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: SizedBox(
        height: 400, // تحديد ارتفاع ثابت أو استخدام Expanded
        child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          columns: [
            DataColumn2(label: Text(lang.code, style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn2(label: Text(lang.account, style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn2(numeric: true, label: Text(lang.totalDebit, style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn2(numeric: true, label: Text(lang.totalCredit, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: items.map((item) => DataRow(cells: [
            DataCell(Text(item.accountCode)),
            DataCell(Text(item.accountName)),
            DataCell(Text(item.totalDebit.toStringAsFixed(2))),
            DataCell(Text(item.totalCredit.toStringAsFixed(2))),
          ])).toList(),
        ),
      ),
    );
  }
}