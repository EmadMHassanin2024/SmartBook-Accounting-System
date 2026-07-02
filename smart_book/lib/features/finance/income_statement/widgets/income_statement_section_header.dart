import 'package:flutter/material.dart';

// تأكد من استيراد كلاس الـ Model الخاص بك هنا
// import '../models/income_statement_model.dart';

class IncomeStatementSection extends StatelessWidget {
  final String title;
  final List<dynamic> items; // استبدل dynamic بنوع الكلاس الخاص بالعنصر (مثلاً RevenueItem)

  const IncomeStatementSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey.shade300),
            ),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
            },
            children: [
              // صف العنوان
              const TableRow(
                children: [
                  Padding(padding: EdgeInsets.all(12), child: Text("الحساب", style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(12), child: Text("المبلغ", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              // صفوف البيانات
              ...items.map((item) => TableRow(
                children: [
                  Padding(padding: const EdgeInsets.all(12), child: Text((item.accountName ?? "غير معروف"))),
                  Padding(padding: const EdgeInsets.all(12), child: Text(item.amount.toStringAsFixed(2))),
                ],
              )).toList(),
            ],
          ),
        ],
      ),
    );
  }
}