// lib/features/finance/income_statement/widgets/income_statement_table.dart
import 'package:data_table_2/data_table_2.dart';

import '../../../../core/packages.dart';

import '../data/models/income_statement_item.dart';
import '../data/models/income_statement_model.dart';

class IncomeStatementSection extends StatelessWidget {
  final String title;
  final List<IncomeStatementItem> items;

  const IncomeStatementSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: items.length * 50 + 50,
          child: DataTable2(
            columnSpacing: 12,
            columns: const [
              DataColumn2(label: Text('الحساب'), size: ColumnSize.L),
              DataColumn2(label: Text('المبلغ'), numeric: true),
            ],
            rows: items.map((item) => DataRow(cells: [
              DataCell(Text(item.accountName)),
              DataCell(Text(item.amount.toStringAsFixed(2))),
            ])).toList(),
          ),
        ),
      ],
    );
  }
}