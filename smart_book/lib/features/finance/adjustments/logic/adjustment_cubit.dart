

import '../../../../core/packages.dart';

import '../../repositories/FinancialReportsRepository.dart';
import '../models/adjustment_entry.dart';
import '../widgets/adjustment_form.dart';
import 'adjustment_state.dart';

class AdjustmentCubit extends Cubit<AdjustmentState> {
  final FinancialReportsRepository repository;

  AdjustmentCubit(this.repository) : super(const AdjustmentInitial());

  // أضفنا المتغير date للدالة لنتمكن من جلب تسويات فترة محددة
  Future<void> fetchAdjustments(DateTime date) async {
    try {
      emit(const AdjustmentLoading());

      // استدعاء الـ repository بجلب البيانات بناءً على التاريخ
      final adjustments = await repository.getAdjustments(date);

      emit(AdjustmentLoaded(adjustments));
    } catch (e, stackTrace) {
      debugPrint('❌ AdjustmentCubit Error: $e');
      debugPrint(stackTrace.toString());

      emit(AdjustmentError(e.toString()));
    }
  }

  // التحديث يقوم باستدعاء نفس التاريخ الحالي (يمكنك تحسينها بحفظ آخر تاريخ تم طلبه)
  Future<void> refresh() async {
    await fetchAdjustments(DateTime.now());
  }

// في ملف adjustment_cubit.dart
  Future<void> submitAdjustment(AdjustmentEntry transaction) async {
    try {
      emit(const AdjustmentLoading());

      // إرسال البيانات للـ repository
      await repository.saveAdjustment(transaction);
// إرسال حالة النجاح مع رسالة
      emit(const AdjustmentSuccess("تم حفظ التسوية بنجاح!"));
      // بعد النجاح، نقوم بتحديث القائمة تلقائياً
      await fetchAdjustments(DateTime.now());
    } catch (e) {
      emit(AdjustmentError(e.toString()));
    }
  }

}