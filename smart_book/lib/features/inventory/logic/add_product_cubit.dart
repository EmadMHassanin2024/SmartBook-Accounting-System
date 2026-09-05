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

  // 3. دالة تعيين الوحدات الأولية عند فتح الشاشة للتعديل
  void setInitialUnits(List<ProductUnitModel> units) {
    emit(AddProductUnitsUpdated(units: units));
  }

  // 4. دالة التحديث الديناميكي والذكاء المحاسبي لاحتساب أسعار الجملة تلقائياً
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

  // 5. الدالة لإضافة منتج جديد بالسيرفر
  Future<void> submitProduct({
    required String name,
    required String barcode,
    required double stock,
    String? expiryDate,
    String? batchNumber,
    bool? isIngredient,
    String? size,
    String? color,
    String itemType = 'general',
  }) async {
    final List<ProductUnitModel> allUnits = state.units;

    emit(AddProductLoading(units: state.units));
    try {
      bool success = await productService.addProduct(
        name: name,
        barcode: barcode,
        totalStockQuantity: stock.toDouble(),
        itemType: itemType,
        productUnits: allUnits,
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

  // 6. الدالة المفقودة لتعديل منتج موجود مسبقاً
  Future<void> updateProduct({
    required int productId,
    required String name,
    required String barcode,
    required double totalStockQuantity,
    String? expiryDate,
    String? batchNumber,
    bool isIngredient = false,
    String? size,
    String? color,
    required String itemType,
    required List<ProductUnitModel> productUnits,
  }) async {
    emit(AddProductLoading(units: state.units));
    try {
      bool success = await productService.updateProduct(
        id: productId,
        name: name,
        barcode: barcode,
        totalStockQuantity: totalStockQuantity,
        itemType: itemType,
        productUnits: productUnits,
      );

      if (success) {
        emit(AddProductSuccess());
      } else {
        emit(AddProductError("فشل تحديث المنتج في الخادم", units: state.units));
      }
    } catch (e) {
      emit(AddProductError("حدث خطأ استثنائي: ${e.toString()}", units: state.units));
    }
  }
}