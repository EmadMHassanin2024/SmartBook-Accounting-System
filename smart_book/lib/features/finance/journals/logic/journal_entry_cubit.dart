//مسؤولاً فقط عن بناء وإرسال القيد الجديد (العمليات المحلية)
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/JournalDetailModel.dart';
import '../models/JournalModel.dart';
import '../repositories/JournalRepository.dart';
import 'journal_entry_state.dart';

class JournalEntryCubit extends Cubit<JournalEntryState> {
  final JournalRepository _journalRepository;

  final List<JournalDetailModel> _lines = [];

  JournalEntryCubit(this._journalRepository)
      : super(JournalEntryInitial());

  /// Read Only List (Encapsulation)
  List<JournalDetailModel> get lines =>
      List.unmodifiable(_lines);

  double get totalDebit =>
      _lines.fold(
        0.0,
            (sum, item) => sum + item.debit,
      );

  double get totalCredit =>
      _lines.fold(
        0.0,
            (sum, item) => sum + item.credit,
      );

  /// المقارنة بين الـ double لا تتم باستخدام ==
  bool get isBalanced =>
      _lines.isNotEmpty &&
          (totalDebit - totalCredit).abs() < 0.001 &&
          totalDebit > 0;

  void addLine(JournalDetailModel line) {
    _lines.add(line);
    _triggerUpdate();
  }

  void removeLine(int index) {
    _lines.removeAt(index);
    _triggerUpdate();
  }


  Future<void> postJournal(int entryId) async {

    emit(JournalEntrySubmitting());
    try {
      bool success = await _journalRepository.postJournal(entryId);
      
      if (success) {
        // فقط أخبر النظام أن الترحيل نجح
        emit(const JournalEntrySuccess("تم ترحيل القيد بنجاح"));

        // لا تستدعِ fetchAllJournals هنا!
      } else {
        emit(const JournalEntryFailure("فشل الترحيل"));
      }
    } catch (e) {
      emit(JournalEntryFailure(e.toString()));
    }
  }
  Future<void> submitJournalEntry({
    required DateTime date,
    required String refNo,
    required String description,
  }) async {
    emit(JournalEntrySubmitting());

    try {
      final journal = JournalModel(
        entryId: 0,
        referenceNo: refNo,
        description: description,
        entryDate: date.toIso8601String(),
        totalDebit: totalDebit,
        totalCredit: totalCredit,
        details: List.unmodifiable(_lines),
      );

      final success =
      await _journalRepository.saveJournal(journal);

      if (success) {
        _lines.clear();

        emit(
          const JournalEntrySuccess(
            "تم ترحيل القيد بنجاح",
          ),
        );

        _triggerUpdate();
      } else {
        emit(
          const JournalEntryFailure(
            "فشل الحفظ على السيرفر",
          ),
        );
      }
    } catch (e) {
      emit(
        JournalEntryFailure(
          e.toString(),
        ),
      );
    }
  }

  void _triggerUpdate() {
    emit(
      JournalEntryLinesUpdated(
        lines: List.unmodifiable(_lines),
        totalDebit: totalDebit,
        totalCredit: totalCredit,
        isBalanced: isBalanced,
      ),
    );
  }
}