
import '../../../models/ ProductUnitModel.dart';

abstract class AddProductState {
  final List<ProductUnitModel> units;
  AddProductState({required this.units});
}

// الحالة الافتتاحية عند فتح الشاشة
class AddProductInitial extends AddProductState {
  AddProductInitial({required super.units});
}

// حالة التحديث المستمر عند إضافة وحدة، حذف وحدة، أو تعديل الأسعار والأسماء
class AddProductUnitsUpdated extends AddProductState {
  AddProductUnitsUpdated({required super.units});
}

// حالة التحميل أثناء إرسال البيانات للسيرفر
class AddProductLoading extends AddProductState {
  AddProductLoading({required super.units});
}

// حالة النجاح التام (نمرر مصفوفة فارغة لأن الشاشة ستغلق)
class AddProductSuccess extends AddProductState {
  AddProductSuccess() : super(units: []);
}

// حالة الخطأ مع الاحتفاظ بالقائمة الحالية للمستخدم حتى لا تضيع بياناته المدخلة
class AddProductError extends AddProductState {
  final String message;
  AddProductError(this.message, {required super.units});
}