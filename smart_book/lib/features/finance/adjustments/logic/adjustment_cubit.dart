

import '../../../../core/packages.dart';

import '../../repositories/FinancialReportsRepository.dart';
import '../models/adjustment_entry.dart';
import '../widgets/adjustment_form.dart';
import 'adjustment_state.dart';

class AdjustmentCubit extends Cubit<AdjustmentState> {
  final FinancialReportsRepository repository;

  AdjustmentCubit(this.repository) : super(const AdjustmentInitial());

//جلب قائمة التسويات الخاصة بتاريخ محدد وعرضها.
  Future<void> fetchAdjustments(DateTime date) async {
    try {
      emit(const AdjustmentLoading());

      final adjustments = await repository.getAdjustments(date);

      emit(AdjustmentLoaded(adjustments));
    } catch (e, stackTrace) {


      emit(AdjustmentError(e.toString()));
    }
  }

//إعادة تحميل تسويات اليوم الحالي.
  Future<void> refresh() async {
    await fetchAdjustments(DateTime.now());
  }

 //
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