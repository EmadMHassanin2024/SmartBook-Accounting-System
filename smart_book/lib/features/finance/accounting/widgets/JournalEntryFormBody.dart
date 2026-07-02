import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/journal_entry_cubit.dart';
import '../logic/journal_entry_state.dart';
import '../models/JournalDetailModel.dart';
import '../widgets/JournalLineCard.dart';
import '../widgets/JournalTotalsFooter.dart';
import '../widgets/journal_components.dart';
import 'AddJournalLinePage.dart';

class JournalEntryFormBody extends StatefulWidget {
  final Map<String, dynamic>? journalToEdit;
  const JournalEntryFormBody({super.key, this.journalToEdit});

  @override
  State<JournalEntryFormBody> createState() => _JournalEntryFormBodyState();
}

class _JournalEntryFormBodyState extends State<JournalEntryFormBody> {
  late TextEditingController _refController;
  late TextEditingController _descController;
  late ValueNotifier<DateTime> _selectedDateNotifier;

  @override
  void initState() {
    super.initState();
    // 1. تهيئة الـ Controllers دائماً
    _refController = TextEditingController(text: widget.journalToEdit?['referenceNo'] ?? '');
    _descController = TextEditingController(text: widget.journalToEdit?['description'] ?? '');

    // 2. تهيئة التاريخ
    DateTime initialDate = DateTime.now();
    if (widget.journalToEdit != null && widget.journalToEdit!['entryDate'] != null) {
      initialDate = DateTime.tryParse(widget.journalToEdit!['entryDate']) ?? DateTime.now();
    }
    _selectedDateNotifier = ValueNotifier<DateTime>(initialDate);

    // 3. (إضافي) إذا كنت تريد تحميل الأسطر القديمة أيضاً
    if (widget.journalToEdit != null && widget.journalToEdit!['details'] != null) {
      // استدعاء دالة في الـ Cubit لتحميل البيانات القديمة للأسطر
      context.read<JournalEntryCubit>().loadExistingLines(widget.journalToEdit!['details']);
    }
  }

  @override
  void dispose() {
    _refController.dispose();
    _descController.dispose();
    _selectedDateNotifier.dispose();
    super.dispose();
  }

  // دالة التنقل للصفحة الجديدة
  void _navigateToLineEntry(BuildContext context, JournalEntryCubit cubit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddJournalLinePage(
          onAdd: (newDetail) {
            cubit.addLine(newDetail);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalEntryCubit, JournalEntryState>(
      builder: (context, state) {
        final cubit = context.read<JournalEntryCubit>();

        return Column(
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _selectedDateNotifier,
              builder: (context, currentDate, _) {
                return JournalHeaderSection(
                  refController: _refController,
                  descController: _descController,
                  selectedDate: currentDate,
                  onPickDate: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: currentDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) _selectedDateNotifier.value = picked;
                  },
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton.icon(
                onPressed: () => _navigateToLineEntry(context, cubit),
                icon: const Icon(Icons.add),
                label: const Text("إضافة سطر مالي"),
              ),
            ),

            Expanded(
              child: cubit.lines.isEmpty
                  ? const Center(child: Text("لا توجد أسطر تفصيلية مضافة."))
                  : ListView.builder(
                itemCount: cubit.lines.length,
                itemBuilder: (context, index) => JournalLineCard(
                  item: cubit.lines[index],
                  onDelete: () => cubit.removeLine(index),
                ),
              ),
            ),

            JournalTotalsFooter(
              debit: cubit.totalDebit,
              credit: cubit.totalCredit,
              isBalanced: cubit.isBalanced,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cubit.isBalanced && cubit.lines.isNotEmpty
                        ? Colors.blue.shade700
                        : Colors.grey.shade400,
                  ),
                  onPressed: () {
                    cubit.submitJournalEntry(
                      date: _selectedDateNotifier.value,
                      refNo: _refController.text,
                      description: _descController.text,
                    );
                  },
                  child: const Text("ترحيل واعتماد القيد", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}