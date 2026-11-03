import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final InventoryRepository productRepository;
  final ProductModel? productToEdit;

  AddProductCubit({
    required this.productRepository,
    this.productToEdit,
  }) : super(AddProductInitial(
    units: [
      const ProductUnitModel(
        unitName: 'قطعة',
        salePrice: 0.0,
        purchasePrice: 0.0,
        conversionFactor: 1.0,
        isBaseUnit: true,
      )
    ],
    expiryDate: null,
  ));

  // تحديث تاريخ الصلاحية فقط
  void setExpiryDate(String date) {
    emit(AddProductStateModified(
      units: state.units,
      expiryDate: date,
    ));
  }

  // 1. دالة إضافة وحدة بيع جديدة
  void addUnit() {
    final updatedUnits = List<ProductUnitModel>.from(state.units);
    updatedUnits.add(const ProductUnitModel(
      unitName: '',
      salePrice: 0.0,
      purchasePrice: 0.0,
      conversionFactor: 1.0,
      isBaseUnit: false,
    ));
    emit(AddProductUnitsUpdated(
      units: updatedUnits,
      expiryDate: state.expiryDate,
    ));
  }

  // 2. دالة حذف وحدة بيع فرعية بناءً على الـ index
  void removeUnit(int index) {
    final updatedUnits = List<ProductUnitModel>.from(state.units);
    if (index < updatedUnits.length) {
      updatedUnits.removeAt(index);
      emit(AddProductUnitsUpdated(
        units: updatedUnits,
        expiryDate: state.expiryDate,
      ));
    }
  }

  // 3. دالة تعيين الوحدات الأولية عند فتح الشاشة للتعديل
  void setInitialUnits(List<ProductUnitModel> units) {
    emit(AddProductUnitsUpdated(
      units: units.isEmpty ? state.units : units,
      expiryDate: state.expiryDate,
    ));
  }

  // 4. دالة التحديث المباشر لبيانات الوحدة
  void updateUnitData({
    required int index,
    String? name,
    double? salePrice,
    double? purchasePrice,
  }) {
    final updatedUnits = List<ProductUnitModel>.from(state.units);
    if (index < updatedUnits.length) {
      final unit = updatedUnits[index];

      updatedUnits[index] = ProductUnitModel(
        unitName: name ?? unit.unitName,
        salePrice: salePrice ?? unit.salePrice,
        purchasePrice: purchasePrice ?? unit.purchasePrice,
        conversionFactor: 1.0,
        isBaseUnit: unit.isBaseUnit,
      );

      if (index == 0) {
        final updatedBaseUnit = updatedUnits[0];
        for (int i = 1; i < updatedUnits.length; i++) {
          final currentSubUnit = updatedUnits[i];
          updatedUnits[i] = ProductUnitModel(
            unitName: currentSubUnit.unitName,
            salePrice: updatedBaseUnit.salePrice,
            purchasePrice: updatedBaseUnit.purchasePrice,
            conversionFactor: 1.0,
            isBaseUnit: false,
          );
        }
      }

      emit(AddProductUnitsUpdated(
        units: updatedUnits,
        expiryDate: state.expiryDate,
      ));
    }
  }
// 8. دالة إضافية لحساب إجمالي القيمة أو السعر إذا تطلب الأمر
  double calculateTotalValue() {
    double total = 0.0;
    for (var unit in state.units) {
      total += (unit.salePrice * unit.conversionFactor);
    }
    return total;
  }

  // دالة لاختيار وتنسيق التاريخ
  Future<void> selectAndSetExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // تنسيق التاريخ بالطريقة التي تريدها
      final formattedDate = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';

      // حفظه في حالة الكيوبت
      setExpiryDate(formattedDate);
    }
  }
  // 5. الدالة لإضافة منتج جديد بالسيرفر
  Future<void> submitProduct({
    required String name,
    required String barcode,
    required double stock,
    String? expiryDate,
    String? batchNumber,
    String? size,
    String? color,

  }) async {
    final List<ProductUnitModel> allUnits = state.units;

    emit(AddProductLoading(
      units: state.units,
      expiryDate: state.expiryDate,
    ));
    try {
      bool success = await productRepository.addProduct(
        name: name,
        barcode: barcode,
        totalStockQuantity: stock,

        productUnits: allUnits,
      );

      if (success) {
        emit(AddProductSuccess(
          units: state.units,
          expiryDate: state.expiryDate,
        ));
      } else {
        emit(AddProductError(
          "فشل السيرفر في حفظ بيانات الصنف الجديد",
          units: state.units,
          expiryDate: state.expiryDate,
        ));
      }
    } catch (e) {
      emit(AddProductError(
        "حدث خطأ استثنائي: ${e.toString()}",
        units: state.units,
        expiryDate: state.expiryDate,
      ));
    }
  }

  // 6. دالة onSave للتحقق وتوجيه العملية (إضافة أو تعديل)
  void onSave({
    required BuildContext context,

    required ProductModel? productToEdit,
    required String name,
    required String barcode,
    required double stock,
    String? expiryDate,
    String? batchNumber,
    String? size,
    String? color,
  }) {
    if (state.units.isEmpty) {
      SnackbarHelper.show(context.lang.pleaseAddUnit, const Color(0xFFFFB300), icon: Icons.warning_amber_rounded);
      return;
    }

    if (state.units.first.salePrice <= 0) {
      SnackbarHelper.show(context.lang.pleaseSetBaseSalePrice, const Color(0xFFFFB300), icon: Icons.warning_amber_rounded);
      return;
    }

    final bool isEditing = productToEdit != null;

    if (isEditing) {
      updateProduct(
        productId: productToEdit.id,

        name: name,
        barcode: barcode,
        totalStockQuantity: stock,
        expiryDate: expiryDate,
        batchNumber: batchNumber,
        size: size,
        color: color,
        productUnits: state.units,
      );
    } else {
      submitProduct(

        name: name,
        barcode: barcode,
        stock: stock,
        expiryDate: expiryDate,
        batchNumber: batchNumber,
        size: size,
        color: color,
      );
    }
  }

  // 7. الدالة لتعديل منتج موجود مسبقاً
  Future<void> updateProduct({
    required int productId,

    required String name,
    required String barcode,
    required double totalStockQuantity,
    String? expiryDate,
    String? batchNumber,
    String? size,
    String? color,

    required List<ProductUnitModel> productUnits,
  }) async {
    emit(AddProductLoading(
      units: state.units,
      expiryDate: state.expiryDate,
    ));
    try {
      bool success = await productRepository.updateProduct(
        id: productId,
        name: name,
        barcode: barcode,
        totalStockQuantity: totalStockQuantity,
        expiryDate: expiryDate,
        batchNumber: batchNumber,
        size: size,
        color: color,

        productUnits: productUnits,
      );

      if (success) {
        emit(AddProductSuccess(
          units: state.units,
          expiryDate: state.expiryDate,
        ));
      } else {
        emit(AddProductError(
          "فشل تحديث المنتج في الخادم",
          units: state.units,
          expiryDate: state.expiryDate,
        ));
      }
    } catch (e) {
      emit(AddProductError(
        "حدث خطأ استثنائي: ${e.toString()}",
        units: state.units,
        expiryDate: state.expiryDate,
      ));
    }
  }
}