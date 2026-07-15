import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/journal_entry_cubit.dart';
import '../logic/journal_entry_state.dart';
import '../logic/JournalListCubit.dart'; // استيراد كيوبت القائمة
import 'AddJournalLinePage.dart';
import '../models/JournalDetailModel.dart';

class JournalEntryFormBody extends StatelessWidget {
  const JournalEntryFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم BlocListener للاستماع لنجاح الترحيل فقط
    return BlocListener<JournalEntryCubit, JournalEntryState>(
      listener: (context, state) {
        if (state is JournalEntrySuccess) {
          // بمجرد نجاح الترحيل، نطلب من كيوبت القائمة تحديث نفسه
          context.read<JournalListCubit>().fetchJournals();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is JournalEntryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<JournalEntryCubit, JournalEntryState>(
        buildWhen: (previous, current) =>
        current is JournalEntryLinesUpdated || current is JournalEntrySubmitting,
        builder: (context, state) {

          if (state is JournalEntrySubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cubit = context.read<JournalEntryCubit>();
          final List<JournalDetailModel> lines = cubit.lines;
          final double totalDebit = cubit.totalDebit;
          final double totalCredit = cubit.totalCredit;

          return Column(
            children: [
              Expanded(
                child: lines.isEmpty
                    ? const Center(child: Text("لا توجد أسطر مضافة، ابدأ بإضافة قيد"))
                    : ListView.builder(
                  itemCount: lines.length,
                  itemBuilder: (context, index) {
                    final line = lines[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(line.accountName),
                        subtitle: Text(line.description),
                        trailing: Text("مد: ${line.debit} | دائـ: ${line.credit}"),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("المدين: $totalDebit", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      Text("الدائن: $totalCredit", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<JournalEntryCubit>(),
                              child: const AddJournalLinePage(),
                            ),
                          ),
                        );
                      },
                      label: const Text("إضافة سطر جديد"),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (cubit.isBalanced && lines.isNotEmpty) ? Colors.green : Colors.grey,
                        ),
                        onPressed: (cubit.isBalanced && lines.isNotEmpty)
                            ? () {
                          context.read<JournalEntryCubit>().submitJournalEntry(
                            date: DateTime.now(),
                            refNo: "REF-001",
                            description: "قيد يومية يدوي",
                          );
                        }
                            : null,
                        child: const Text("ترحيل واعتماد القيد", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}