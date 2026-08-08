import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepository productService;

  // تهيئة الـ Cubit بالوحدة الأساسية الافتراضية (قطعة) من أول ثانية
  AddProductCubit(this.productService)
      : super(AddProductInitial(units: [
    ProductUnitModel(
      unitName: 'قطعة',
      salePrice: 0.0,
      purchasePrice: 0.0,
      conversionFactor: 1.0,
      isBaseUnit: true,
    )
  ]));

  // 1. دالة إضافة وحدة بيع فرعية جديدة (جملة / كرتونة ..الخ)
  void addUnit() {
    final updatedUnits = List<ProductUnitModel>.from(state.units);
    updatedUnits.add(ProductUnitModel(
      unitName: '',
      salePrice: 0.0,
      purchasePrice: 0.0,
      conversionFactor: 1.0,
      isBaseUnit: false,
    ));
    emit(AddProductUnitsUpdated(units: updatedUnits));
  }

  // 2. دالة حذف وحدة بيع فرعية بناءً على الـ index
  void removeUnit(int index) {
    final updatedUnits = List<ProductUnitModel>.from(state.units);
    if (index < updatedUnits.length) {
      updatedUnits.removeAt(index);
      emit(AddProductUnitsUpdated(units: updatedUnits));
    }
  }

  // 3. دالة التحديث الديناميكي والذكاء المحاسبي لاحتساب أسعار الجملة تلقائياً
  void updateUnitData({
    required int index,
    String? name,
    double? salePrice,
    double? purchasePrice,
    double? conversionFactor,
  }) {
    final updatedUnits = List<ProductUnitModel>.from(state.units);
    if (index < updatedUnits.length) {
      final unit = updatedUnits[index];

      // 1. استقبال القيم الجديدة أو الاحتفاظ بالقديمة
      double newFactor = conversionFactor ?? unit.conversionFactor;
      double? newSalePrice = salePrice;
      double? newPurchasePrice = purchasePrice;

      // 🔥 2. تعديل الذكاء المحاسبي الصحيح (سعر القطعة × عدد القطع)
      if (index > 0 && conversionFactor != null) {
        final baseUnit = updatedUnits[0]; // الوحدة الأساسية

        if (baseUnit.salePrice > 0) {
          newSalePrice = baseUnit.salePrice * newFactor;
        }
        if (baseUnit.purchasePrice > 0) {
          newPurchasePrice = baseUnit.purchasePrice * newFactor;
        }
      }

      // تحديث الوحدة الحالية في المصفوفة
      updatedUnits[index] = ProductUnitModel(
        unitName: name ?? unit.unitName,
        salePrice: newSalePrice ?? unit.salePrice,
        purchasePrice: newPurchasePrice ?? unit.purchasePrice,
        conversionFactor: newFactor,
        isBaseUnit: unit.isBaseUnit,
      );

      // 🔥 3. التحديث التلقائي المتسلسل (النزولي)
      if (index == 0) {
        final updatedBaseUnit = updatedUnits[0];
        for (int i = 1; i < updatedUnits.length; i++) {
          final currentSubUnit = updatedUnits[i];
          updatedUnits[i] = ProductUnitModel(
            unitName: currentSubUnit.unitName,
            salePrice: updatedBaseUnit.salePrice * currentSubUnit.conversionFactor,
            purchasePrice: updatedBaseUnit.purchasePrice * currentSubUnit.conversionFactor,
            conversionFactor: currentSubUnit.conversionFactor,
            isBaseUnit: false,
          );
        }
      }

      emit(AddProductUnitsUpdated(units: updatedUnits));
    }
  }

  // 4. الدالة المحسنة والمطورة لحفظ المنتج النهائي بالسيرفر وتفكيك المتغيرات محاسبياً
  Future<void> submitProduct({
    required String name,
    required String barcode,
    required int stock,
    String? expiryDate,
    String? batchNumber,
    bool? isIngredient,
    String? size,
    String? color,
    String itemType = 'general', // نوع النشاط المستلم من الشاشة
  }) async {
    // التقاط بيانات الوحدة الأساسية (الأولى دائمًا في المصفوفة)
    final baseUnit = state.units.first;

    emit(AddProductLoading(units: state.units));
    try {
      // 💡 التعديل هنا: تمرير itemType إلى دالة الـ Repository ليتم حفظه بشكل صحيح
      bool success = await productService.addProduct(
        name: name,
        barcode: barcode,
        price: baseUnit.salePrice,
        purchasePrice: baseUnit.purchasePrice,
        stock: stock,
        unitName: baseUnit.unitName.trim().isEmpty ? "قطعة" : baseUnit.unitName.trim(),
        itemType: itemType, // 👈 إرسال النوع الفعلي (restaurant أو pharmacy) للسيرفر
      );

      if (success) {
        emit(AddProductSuccess());
      } else {
        emit(AddProductError("فشل السيرفر في حفظ بيانات الصنف الجديد", units: state.units));
      }
    } catch (e) {
      emit(AddProductError("حدث خطأ استثنائي: ${e.toString()}", units: state.units));
    }
  }
}