import 'package:flutter/material.dart';
import '../models/JournalDetailModel.dart';

class AddJournalLinePage extends StatefulWidget {
  final Function(JournalDetailModel) onAdd;

  const AddJournalLinePage({super.key, required this.onAdd});

  @override
  State<AddJournalLinePage> createState() => _AddJournalLinePageState();
}

class _AddJournalLinePageState extends State<AddJournalLinePage> {
  final TextEditingController _debitCtrl = TextEditingController(text: '0.0');
  final TextEditingController _creditCtrl = TextEditingController(text: '0.0');
  final TextEditingController _lineDescCtrl = TextEditingController();

  @override
  void dispose() {
    _debitCtrl.dispose();
    _creditCtrl.dispose();
    _lineDescCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة حركة سطر محاسبي")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // هنا يمكنك إضافة زر لاختيار الحساب مستقبلاً
            ListTile(
              title: const Text("حساب الصندوق الرئيسي"),
              leading: const Icon(Icons.account_balance_wallet, color: Colors.indigo),
              tileColor: Colors.grey.shade100,
            ),
            const SizedBox(height: 20),
            TextFormField(controller: _debitCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "المدين (Debit)", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextFormField(controller: _creditCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "الدائن (Credit)", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextFormField(controller: _lineDescCtrl, decoration: const InputDecoration(labelText: "البيان التفصيلي", border: OutlineInputBorder())),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final d = double.tryParse(_debitCtrl.text) ?? 0.0;
                  final c = double.tryParse(_creditCtrl.text) ?? 0.0;
                  if (d > 0 || c > 0) {
                    widget.onAdd(JournalDetailModel(
                      accountId: 1, // سيتم استبداله برقم الحساب الفعلي
                      accountName: "حساب الصندوق الرئيسي",
                      debit: d,
                      credit: c,
                      description: _lineDescCtrl.text,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text("إضافة للجدول"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}