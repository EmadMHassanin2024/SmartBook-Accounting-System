import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/JournalRepository.dart';
import 'JournalListState.dart';
import '../models/JournalModel.dart';

class JournalListCubit extends Cubit<JournalListState> {
  final JournalRepository repository;

  // قائمة إضافية للاحتفاظ بالبيانات الأصلية للبحث فيها بدون استدعاء الـ API
  List<JournalModel> _allJournals = [];

  JournalListCubit(this.repository) : super(JournalListInitial());

  Future<void> fetchJournals() async {
    emit(JournalListLoading());
    try {
      // 1. جلب البيانات من الـ Repository
      final journals = await repository.getAllJournals();

      // 2. تحديث النسخة الأصلية
      _allJournals = List.from(journals);

      // 3. الترتيب
      _allJournals.sort((a, b) => b.entryId.compareTo(a.entryId));

      // 4. إرسال الحالة
      emit(JournalListLoaded(_allJournals));
    } catch (e) {
      emit(JournalListFailure(e.toString()));
    }
  }

  void searchJournals(String query) {
    // التأكد أن البيانات محملة
    if (_allJournals.isEmpty && state is! JournalListLoaded) return;

    // إزالة المسافات الزائدة
    final String trimmedQuery = query.trim().toLowerCase();

    // إذا مربع البحث فارغ، نعيد القائمة الأصلية
    if (trimmedQuery.isEmpty) {
      emit(JournalListLoaded(List.from(_allJournals)));
      return;
    }

    // البحث في القائمة الأصلية المحفوظة
    final filteredList = _allJournals.where((journal) {
      return journal.description.toLowerCase().contains(trimmedQuery) ||
          journal.entryId.toString().contains(trimmedQuery);
    }).toList();

    emit(JournalListLoaded(filteredList));
  }


  Future<void> deleteJournal(int entryId) async {
    try {
      await repository.deleteJournal(entryId);
      // بعد الحذف، نقوم بجلب البيانات من جديد لتحديث النسخة الأصلية _allJournals
      await fetchJournals();
    } catch (e) {
      emit(JournalListFailure("فشل الحذف: ${e.toString()}"));
    }
  }
}