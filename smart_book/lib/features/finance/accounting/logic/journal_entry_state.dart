import '../models/JournalDetailModel.dart';

abstract class JournalEntryState {}

class JournalEntryInitial extends JournalEntryState {}

// حالة تحديث البيانات ديناميكياً
class JournalEntryLinesUpdated extends JournalEntryState {
  final List<JournalDetailModel> lines;
  final double totalDebit;
  final double totalCredit;
  final bool isBalanced;

  JournalEntryLinesUpdated({
    required this.lines,
    required this.totalDebit,
    required this.totalCredit,
    required this.isBalanced,
  });
}

// حالات التعامل مع الـ API
class JournalEntryLoading extends JournalEntryState {} // جديدة للجلب
class JournalEntrySubmitting extends JournalEntryState {}
class JournalEntrySuccess extends JournalEntryState {
  final String message;
  JournalEntrySuccess(this.message);
}
class JournalEntryFailure extends JournalEntryState {
  final String error;
  JournalEntryFailure(this.error);
}

// حالة نجاح جلب البيانات
class JournalEntriesLoaded extends JournalEntryState {
  final List<dynamic> entries;
  JournalEntriesLoaded(this.entries);
}