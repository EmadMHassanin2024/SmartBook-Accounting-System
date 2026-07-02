import 'package:flutter_bloc/flutter_bloc.dart';
import '../../journals/repositories/JournalRepository.dart';
import '../../journals/models/JournalModel.dart'; // استيراد الموديل الأساسي
import '../models/JournalDetailModel.dart';
import 'journal_entry_state.dart';

class JournalEntryCubit extends Cubit<JournalEntryState> {
  final JournalRepository _journalRepository = JournalRepository();

  final List<JournalDetailModel> _lines = [];
  List<JournalDetailModel> get lines => _lines;

  double get totalDebit => _lines.fold(0, (sum, item) => sum + item.debit);
  double get totalCredit => _lines.fold(0, (sum, item) => sum + item.credit);
  bool get isBalanced => _lines.isNotEmpty && totalDebit == totalCredit && totalDebit > 0;

  JournalEntryCubit() : super(JournalEntryInitial());

  void loadExistingLines(List<dynamic> details) {
    try {
      _lines.clear();
      // تحويل البيانات القادمة إلى كائنات JournalDetailModel
      _lines.addAll(details.map((e) => JournalDetailModel.fromJson(e as Map<String, dynamic>)).toList());
      _triggerUpdate();
    } catch (e) {
      emit(JournalEntryFailure("خطأ في تحميل تفاصيل القيد: ${e.toString()}"));
    }
  }

  void addLine(JournalDetailModel line) {
    _lines.add(line);
    _triggerUpdate();
  }

  void removeLine(int index) {
    _lines.removeAt(index);
    _triggerUpdate();
  }

  Future<void> submitJournalEntry({
    required DateTime date,
    required String refNo,
    required String description,
    int? entryId,
  }) async {
    if (!isBalanced) {
      emit(JournalEntryFailure("القيد غير متوازن محاسبياً!"));
      return;
    }

    emit(JournalEntrySubmitting());

    try {
      // بناء كائن JournalModel بدلاً من الـ Map
      final journal = JournalModel(
        entryId: entryId ?? 0,
        referenceNo: refNo.trim().isEmpty ? null : refNo.trim(),
        description: description.trim().isEmpty ? "قيد يومية يدوي" : description.trim(),
        entryDate: date.toIso8601String(),
        totalDebit: totalDebit,
        totalCredit: totalCredit,
        details: List.from(_lines), // إسناد القائمة مباشرة
      );

      bool success;
      if (entryId != null) {
        // الآن نمرر كائن JournalModel
        success = await _journalRepository.updateJournal(entryId, journal);
      } else {
        // الآن نمرر كائن JournalModel
        success = await _journalRepository.saveJournal(journal);
      }

      if (success) {
        emit(JournalEntrySuccess(entryId != null ? "تم تحديث القيد بنجاح" : "تم ترحيل القيد بنجاح"));
        _lines.clear();
        emit(JournalEntryInitial());
      } else {
        emit(JournalEntryFailure("فشل العملية على السيرفر"));
      }
    } catch (e) {
      emit(JournalEntryFailure(e.toString().replaceAll("Exception:", "")));
    }
  }

  void _triggerUpdate() {
    emit(JournalEntryLinesUpdated(
      lines: List.from(_lines),
      totalDebit: totalDebit,
      totalCredit: totalCredit,
      isBalanced: isBalanced,
    ));
  }
}