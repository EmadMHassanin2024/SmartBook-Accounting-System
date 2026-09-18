import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductCubit extends Cubit<AddProductState> {
  // تعريف وتضمين جميع الـ Controllers مباشرة داخل الكيوبيت بداخلة لمنع زحمة المعلمات
  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final stockController = TextEditingController();
  final reorderLevelController = TextEditingController();
  final expiryDateController = TextEditingController();
  final batchController = TextEditingController();
  final sizeController = TextEditingController();
  final colorController = TextEditingController();

  final ProductRepository productService;

  // تهيئة الـ Cubit بالوحدة الأساسية الافتراضية (قطعة) من أول ثانية
  AddProductCubit(this.productService)
      : super(AddProductInitial(
    units: [
      ProductUnitModel(
        unitName: 'قطعة',
        salePrice: 0.0,
        purchasePrice: 0.0,
        conversionFactor: 1.0,
        isBaseUnit: true,
      )
    ],
    isIngredient: false,
    expiryDate: null,
  ));

  @override
  Future<void> close() {
    // التخلص من الـ Controllers لمنع تسريب الذاكرة (Memory Leaks)
    nameController.dispose();
    barcodeController.dispose();
    stockController.dispose();
    reorderLevelController.dispose();
    expiryDateController.dispose();
    batchController.dispose();
    sizeController.dispose();
    colorController.dispose();
    return super.close();
  }

  // تحديث حالة المكون (Ingredient)
  void changeIngredientStatus(bool value) {
    emit(AddProductStateModified(
      isIngredient: value,
      units: state.units,
      expiryDate: state.expiryDate,
    ));
  }

  // تحديث تاريخ الصلاحية
  void setExpiryDate(String date) {
    emit(AddProductStateModified(
      isIngredient: state.isIngredient,
      units: state.units,
      expiryDate: date,
    ));
  }

  // معالجة بيانات إضافة المنتج (تستخدم الـ controllers الداخلية مباشرة)
  void submitProductData({
    required String itemType,
  }) {
    final name = nameController.text.trim();
    final barcode = barcodeController.text.trim();
    final stock = double.tryParse(stockController.text.trim()) ?? 0.0;
    final expiry = _getOptionalText(expiryDateController);
    final batch = _getOptionalText(batchController);
    final size = _getOptionalText(sizeController);
    final color = _getOptionalText(colorController);

    submitProduct(
      name: name,
      barcode: barcode,
      stock: stock,
      expiryDate: expiry,
      batchNumber: batch,
      isIngredient: state.isIngredient,
      size: size,
      color: color,
      itemType: itemType,
    );
  }

  // معالجة بيانات تعديل المنتج وتحويل الـ ID بأمان
  void updateProductData({
    required dynamic productId,
    required String itemType,
    required List<ProductUnitModel> units,
  }) {
    final parsedId = productId is int
        ? productId
        : int.tryParse(productId.toString()) ?? 0;

    final name = nameController.text.trim();
    final barcode = barcodeController.text.trim();
    final stock = double.tryParse(stockController.text.trim()) ?? 0.0;
    final expiry = _getOptionalText(expiryDateController);
    final batch = _getOptionalText(batchController);
    final size = _getOptionalText(sizeController);
    final color = _getOptionalText(colorController);

    updateProduct(
      productId: parsedId,
      name: name,
      barcode: barcode,
      totalStockQuantity: stock,
      expiryDate: expiry,
      batchNumber: batch,
      isIngredient: state.isIngredient,
      size: size,
      color: color,
      itemType: itemType,
      productUnits: units,
    );
  }

  // 1. دالة إضافة وحدة بيع فرعية جديدة (جملة / كرتونة ..الخ)
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
      isIngredient: state.isIngredient,
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
        isIngredient: state.isIngredient,
        expiryDate: state.expiryDate,
      ));
    }
  }

  // 3. دالة تعيين الوحدات الأولية عند فتح الشاشة للتعديل
  void setInitialUnits(List<ProductUnitModel> units) {
    emit(AddProductUnitsUpdated(
      units: units,
      isIngredient: state.isIngredient,
      expiryDate: state.expiryDate,
    ));
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

      double newFactor = conversionFactor ?? unit.conversionFactor;
      double? newSalePrice = salePrice;
      double? newPurchasePrice = purchasePrice;

      if (index > 0 && conversionFactor != null) {
        final baseUnit = updatedUnits[0];

        if (baseUnit.salePrice > 0) {
          newSalePrice = baseUnit.salePrice * newFactor;
        }
        if (baseUnit.purchasePrice > 0) {
          newPurchasePrice = baseUnit.purchasePrice * newFactor;
        }
      }

      updatedUnits[index] = ProductUnitModel(
        unitName: name ?? unit.unitName,
        salePrice: newSalePrice ?? unit.salePrice,
        purchasePrice: newPurchasePrice ?? unit.purchasePrice,
        conversionFactor: newFactor,
        isBaseUnit: unit.isBaseUnit,
      );

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

      emit(AddProductUnitsUpdated(
        units: updatedUnits,
        isIngredient: state.isIngredient,
        expiryDate: state.expiryDate,
      ));
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

    emit(AddProductLoading(
      units: state.units,
      isIngredient: state.isIngredient,
      expiryDate: state.expiryDate,
    ));
    try {
      bool success = await productService.addProduct(
        name: name,
        barcode: barcode,
        totalStockQuantity: stock.toDouble(),
        itemType: itemType,
        productUnits: allUnits,
      );

      if (success) {
        emit(AddProductSuccess(
          units: state.units,
          isIngredient: state.isIngredient,
          expiryDate: state.expiryDate,
        ));
      } else {
        emit(AddProductError(
          "فشل السيرفر في حفظ بيانات الصنف الجديد",
          units: state.units,
          isIngredient: state.isIngredient,
          expiryDate: state.expiryDate,
        ));
      }
    } catch (e) {
      emit(AddProductError(
        "حدث خطأ استثنائي: ${e.toString()}",
        units: state.units,
        isIngredient: state.isIngredient,
        expiryDate: state.expiryDate,
      ));
    }
  }
  bool _controllersInitialized = false;
  // تهيئة المتحكمات باستخدام البيانات المحفوظة داخل الكيوبيت مباشرة
  void initializeControllers({

    required ProductModel? productToEdit,
  }) {
    if (_controllersInitialized) return;
    _controllersInitialized = true;
    final p = productToEdit;
    if (p == null) {
      reorderLevelController.text = '5';
      return;
    }
    nameController.text = p.name;
    barcodeController.text = p.barcode ?? '';
    stockController.text = p.stock.toString();
    reorderLevelController.text = '5';
    expiryDateController.text = p.expiryDate ?? '';
    batchController.text = p.batchNumber ?? '';
    sizeController.text = p.size ?? '';
    colorController.text = p.color ?? '';

    if (p.units.isNotEmpty) {
      setInitialUnits(p.units);
    }
    if (p.isIngredient) {
      changeIngredientStatus(true);
    }
  }

  Future<void> selectExpiryDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    final formattedDate = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    expiryDateController.text = formattedDate;

    // تحديث الحالة داخل الكيوبيت
    setExpiryDate(formattedDate);
  }

  String? _getOptionalText(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  void onSave({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String activityType,
    required ProductModel? productToEdit,
  }) {
    if (!formKey.currentState!.validate()) return;

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
      updateProductData(
        productId: productToEdit.id,
        itemType: activityType,
        units: state.units,
      );
    } else {
      submitProductData(
        itemType: activityType,
      );
    }
  }
/*
  void handleBlocListenerState(BuildContext context, AddProductState state) {
    if (state is AddProductLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
      );
    } else if (state is AddProductError) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      SnackbarHelper.showError(state.message);
    } else if (state is AddProductSuccess) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      SnackbarHelper.showSuccess(context.lang.saveSuccess);
      Navigator.pop(context, true);
    }
  }
 */
  // 6. الدالة لتعديل منتج موجود مسبقاً
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
    emit(AddProductLoading(
      units: state.units,
      isIngredient: state.isIngredient,
      expiryDate: state.expiryDate,
    ));
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
        emit(AddProductSuccess(
          units: state.units,
          isIngredient: state.isIngredient,
          expiryDate: state.expiryDate,
        ));
      } else {
        emit(AddProductError(
          "فشل تحديث المنتج في الخادم",
          units: state.units,
          isIngredient: state.isIngredient,
          expiryDate: state.expiryDate,
        ));
      }
    } catch (e) {
      emit(AddProductError(
        "حدث خطأ استثنائي: ${e.toString()}",
        units: state.units,
        isIngredient: state.isIngredient,
        expiryDate: state.expiryDate,
      ));
    }
  }
}