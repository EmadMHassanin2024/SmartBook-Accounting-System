
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

import '../models/adjustment_entry.dart';
import '../widgets/adjustment_form.dart';

class AdjustmentTable extends StatelessWidget {
  final List<AdjustmentEntry> entries;
  const AdjustmentTable({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        columns: [
          DataColumn2(label: Text(lang.description, style: const TextStyle(fontWeight: FontWeight.bold))),
          DataColumn2(label: Text(lang.adjustmentType, style: const TextStyle(fontWeight: FontWeight.bold))),
          DataColumn2(numeric: true, label: Text(lang.amount, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: entries.map((entry) {
          // دالة مساعدة للحصول على الاسم المحلي للنوع
          String getLocalizedType(AdjustmentType type) {
            switch (type) {
              case AdjustmentType.accrued: return lang.accrued;
              case AdjustmentType.prepaid: return lang.prepaid;
              case AdjustmentType.depreciation: return lang.depreciation;
            }
          }

          return DataRow(cells: [
            DataCell(Text(entry.description)),
            DataCell(Text(getLocalizedType(entry.type))), // عرض الاسم المترجم
            DataCell(Text(entry.amount.toStringAsFixed(2))), // عرض المبلغ
          ]);
        }).toList(),
      ),
    );
  }
}