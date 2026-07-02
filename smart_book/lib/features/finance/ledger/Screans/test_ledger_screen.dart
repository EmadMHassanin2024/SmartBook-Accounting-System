import 'package:flutter/material.dart';
import '../models/ledger_transaction_model.dart'; // تأكد من المسار

class TestLedgerScreen extends StatelessWidget {
  final List<LedgerTransaction> transactions;

  const TestLedgerScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("شاشة اختبار البيانات")),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final item = transactions[index];
          return Card(
            child: ListTile(
              title: Text(item.description),
              subtitle: Text("مدين: ${item.debit} - دائن: ${item.credit}"),
            ),
          );
        },
      ),
    );
  }
}