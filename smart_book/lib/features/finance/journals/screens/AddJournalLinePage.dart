import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/journal_entry_cubit.dart';
import '../models/JournalDetailModel.dart';

class AddJournalLinePage extends StatefulWidget {
  const AddJournalLinePage({super.key});

  @override
  State<AddJournalLinePage> createState() => _AddJournalLinePageState();
}

class _AddJournalLinePageState extends State<AddJournalLinePage> {
  final TextEditingController _debitCtrl = TextEditingController(text: '0.0');
  final TextEditingController _creditCtrl = TextEditingController(text: '0.0');
  final TextEditingController _lineDescCtrl = TextEditingController();

  int? _selectedAccountId;
  final List<Map<String, dynamic>> _accounts = [
    {'id': 1, 'name': 'حساب الصندوق الرئيسي'},
    {'id': 2, 'name': 'حساب البنك'},
    {'id': 3, 'name': 'حساب المبيعات'},
  ];

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
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "اختر الحساب", border: OutlineInputBorder()),
              value: _selectedAccountId,
              items: _accounts.map((acc) {
                return DropdownMenuItem<int>(
                  value: acc['id'],
                  child: Text(acc['name']),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedAccountId = val),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _debitCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: "المدين (Debit)", border: OutlineInputBorder()),
              onChanged: (val) {
                if ((double.tryParse(val) ?? 0) > 0) _creditCtrl.text = "0.0";
              },
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _creditCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: "الدائن (Credit)", border: OutlineInputBorder()),
              onChanged: (val) {
                if ((double.tryParse(val) ?? 0) > 0) _debitCtrl.text = "0.0";
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _lineDescCtrl,
              decoration: const InputDecoration(labelText: "البيان التفصيلي", border: OutlineInputBorder()),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print("تم ضغط الزر - جاري إرسال: ${_lineDescCtrl.text}");
                  final d = double.tryParse(_debitCtrl.text) ?? 0.0;
                  final c = double.tryParse(_creditCtrl.text) ?? 0.0;

                  if (_selectedAccountId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى اختيار الحساب أولاً")));
                    return;
                  }

                  if (d > 0 || c > 0) {
                    final selectedAccount = _accounts.firstWhere((a) => a['id'] == _selectedAccountId);

                    final newDetail = JournalDetailModel(
                      entryId: 0,
                      accountId: _selectedAccountId ?? 0,
                      accountName: selectedAccount['name'],
                      debit: d,
                      credit: c,
                      description: _lineDescCtrl.text,
                    );

                    // هنا الحل: يتم إرسال البيانات للكيوبت
                    context.read<JournalEntryCubit>().addLine(newDetail);

                    // العودة للخلف بعد نجاح الإضافة
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