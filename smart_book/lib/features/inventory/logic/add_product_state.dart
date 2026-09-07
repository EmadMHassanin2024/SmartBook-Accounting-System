import 'package:smart_book/features/inventory/auth_exports.dart';

abstract class AddProductState {
  final List<ProductUnitModel> units;
  final bool isIngredient;
  final String? expiryDate;

  AddProductState({
    required this.units,
    this.isIngredient = false,
    this.expiryDate,
  });
}

// الحالة الافتتاحية عند فتح الشاشة
class AddProductInitial extends AddProductState {
  AddProductInitial({
    required super.units,
    super.isIngredient,
    super.expiryDate,
  });
}

// حالة مخصصة لتحديث الحالات مثل المكونات أو تاريخ الصلاحية أو الوحدات
class AddProductStateModified extends AddProductState {
  AddProductStateModified({
    required super.units,
    required super.isIngredient,
    super.expiryDate,
  });
}

// حالة التحديث المستمر عند إضافة وحدة، حذف وحدة، أو تعديل الأسعار والأسماء
class AddProductUnitsUpdated extends AddProductState {
  AddProductUnitsUpdated({
    required super.units,
    super.isIngredient,
    super.expiryDate,
  });
}

// حالة التحميل أثناء إرسال البيانات للسيرفر
class AddProductLoading extends AddProductState {
  AddProductLoading({
    required super.units,
    super.isIngredient,
    super.expiryDate,
  });
}

// حالة النجاح التام
class AddProductSuccess extends AddProductState {
  AddProductSuccess({
    super.units = const [],
    super.isIngredient,
    super.expiryDate,
  });
}

// حالة الخطأ مع الاحتفاظ بالقائمة الحالية للمستخدم حتى لا تضيع بياناته المدخلة
class AddProductError extends AddProductState {
  final String message;
  AddProductError(
      this.message, {
        required super.units,
        super.isIngredient,
        super.expiryDate,
      });
}