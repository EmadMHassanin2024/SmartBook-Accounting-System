import 'package:equatable/equatable.dart';
import '../models/JournalDetailModel.dart';

abstract class JournalEntryState extends Equatable {
  const JournalEntryState();

  @override
  List<Object?> get props => [];
}

// 1. الحالة الأولية: عند فتح الصفحة لأول مرة
class JournalEntryInitial extends JournalEntryState {}

// 2. حالة تحديث الأسطر (عند إضافة أو حذف سطر من القيد)
class JournalEntryLinesUpdated extends JournalEntryState {
  final List<JournalDetailModel> lines;
  final double totalDebit;
  final double totalCredit;
  final bool isBalanced;

  const JournalEntryLinesUpdated({
    required this.lines,
    required this.totalDebit,
    required this.totalCredit,
    required this.isBalanced,
  });

  @override
  List<Object?> get props => [lines, totalDebit, totalCredit, isBalanced];
}

// 3. حالة انتظار الترحيل (أثناء الاتصال بالسيرفر)
class JournalEntrySubmitting extends JournalEntryState {}

// 4. حالة النجاح (القيد تم حفظه)
class JournalEntrySuccess extends JournalEntryState {
  final String message;
  const JournalEntrySuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// 5. حالة الخطأ (في حال فشل الاتصال أو خطأ في البيانات)
class JournalEntryFailure extends JournalEntryState {
  final String error;
  const JournalEntryFailure(this.error);

  @override
  List<Object?> get props => [error];
}