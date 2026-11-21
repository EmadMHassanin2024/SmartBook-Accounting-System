
import 'package:smart_book/features/inventory/auth_exports.dart';

@immutable
abstract class AddProductState {
  final List<ProductUnitModel> units;
  final String? expiryDate;

  const AddProductState({
    required this.units,
    this.expiryDate,
  });
}

// الحالة الافتتاحية عند فتح الشاشة
class AddProductInitial extends AddProductState {
  const AddProductInitial({
    required super.units,
    super.expiryDate,
  });
}

// حالة مخصصة لتحديث الحالات مثل المكونات أو تاريخ الصلاحية أو الوحدات
class AddProductStateModified extends AddProductState {
  const AddProductStateModified({
    required super.units,
    super.expiryDate,
  });
}

// حالة التحديث المستمر عند إضافة وحدة، حذف وحدة، أو تعديل الأسعار والأسماء
class AddProductUnitsUpdated extends AddProductState {
  const AddProductUnitsUpdated({
    required super.units,
    super.expiryDate,
  });
}

// حالة التحميل أثناء إرسال البيانات للسيرفر
class AddProductLoading extends AddProductState {
  const AddProductLoading({
    required super.units,
    super.expiryDate,
  });
}

// حالة النجاح التام
class AddProductSuccess extends AddProductState {
  const AddProductSuccess({
    super.units = const [],
    super.expiryDate,
  });
}

// حالة الخطأ مع الاحتفاظ بالقائمة الحالية للمستخدم حتى لا تضيع بياناته المدخلة
class AddProductError extends AddProductState {
  final String message;

  const AddProductError(
      this.message, {
        required super.units,
        super.expiryDate,
      });
}