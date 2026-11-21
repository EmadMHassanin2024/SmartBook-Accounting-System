import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final InventoryRepository productRepository;
  ProductModel? productToEdit;
  ProductModel? currentProduct;

  AddProductCubit({
    required this.productRepository,
  }) : super(
    AddProductInitial(
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
    ),
  );

  void initProduct(ProductModel? product) {
    productToEdit = product;
    currentProduct = product;

    if (product != null) {
      if (product.units.isNotEmpty) {
        setInitialUnits(product.units);
      }
      if (product.expiryDate != null) {
        setExpiryDate(product.expiryDate!);
      }
    } else {
      emit(
        AddProductInitial(
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
        ),
      );
    }
  }

  void setExpiryDate(String date) {
    if (isClosed) return;
    emit(
      AddProductStateModified(
        units: state.units,
        expiryDate: date,
      ),
    );
  }

  void addUnit() {
    if (isClosed) return;
    final updatedUnits = List<ProductUnitModel>.from(state.units)
      ..add(
        const ProductUnitModel(
          unitName: '',
          salePrice: 0.0,
          purchasePrice: 0.0,
          conversionFactor: 1.0,
          isBaseUnit: false,
        ),
      );

    emit(
      AddProductUnitsUpdated(
        units: updatedUnits,
        expiryDate: state.expiryDate,
      ),
    );
  }

  void removeUnit(int index) {
    if (isClosed) return;
    final updatedUnits = List<ProductUnitModel>.from(state.units);
    if (index < updatedUnits.length) {
      updatedUnits.removeAt(index);
      emit(
        AddProductUnitsUpdated(
          units: updatedUnits,
          expiryDate: state.expiryDate,
        ),
      );
    }
  }

  void setInitialUnits(List<ProductUnitModel> units) {
    if (isClosed) return;
    emit(
      AddProductUnitsUpdated(
        units: units.isEmpty ? state.units : units,
        expiryDate: state.expiryDate,
      ),
    );
  }

  void updateUnitData({
    required int index,
    String? name,
    double? salePrice,
    double? purchasePrice,
  }) {
    if (isClosed) return;
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

      emit(
        AddProductUnitsUpdated(
          units: updatedUnits,
          expiryDate: state.expiryDate,
        ),
      );
    }
  }

  double calculateTotalValue() {
    double total = 0.0;
    for (var unit in state.units) {
      total += (unit.salePrice * unit.conversionFactor);
    }
    return total;
  }

  Future<void> selectAndSetExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (isClosed) return;

    if (picked != null) {
      final formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setExpiryDate(formattedDate);
    }
  }

  Future<void> submitProduct({
    required String name,
    required String barcode,
    required double stock,
    String? expiryDate,
    String? batchNumber,
    String? size,
    String? color,
    required String itemType,
  }) async {
    final List<ProductUnitModel> allUnits = state.units;

    if (isClosed) return;
    emit(
      AddProductLoading(
        units: state.units,
        expiryDate: state.expiryDate,
      ),
    );

    try {
      final bool success = await productRepository.addProduct(
        name: name,
        barcode: barcode,
        totalStockQuantity: stock,
        productUnits: allUnits,
        itemType: itemType,
      );

      if (isClosed) return;

      if (success) {
        emit(
          AddProductSuccess(
            units: state.units,
            expiryDate: state.expiryDate,
          ),
        );
      } else {
        emit(
          AddProductError(
            "فشل السيرفر في حفظ بيانات الصنف الجديد",
            units: state.units,
            expiryDate: state.expiryDate,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;
      emit(
        AddProductError(
          "حدث خطأ استثنائي: ${e.toString()}",
          units: state.units,
          expiryDate: state.expiryDate,
        ),
      );
    }
  }

  void onSave({
    required BuildContext context,
    required String name,
    required String barcode,
    required double stock,
    String? expiryDate,
    String? batchNumber,
    String? size,
    String? color,
    required String itemType,
  }) {
    if (state.units.isEmpty) {
      SnackbarHelper.showWarning(context.lang.pleaseAddUnit);
      return;
    }

    if (state.units.first.salePrice <= 0) {
      SnackbarHelper.showWarning(context.lang.pleaseSetBaseSalePrice);
      return;
    }

    final bool isEditing = productToEdit != null;

    if (isEditing) {
      updateProduct(
        productId: productToEdit!.id,
        name: name,
        barcode: barcode,
        totalStockQuantity: stock,
        expiryDate: expiryDate,
        batchNumber: batchNumber,
        size: size,
        color: color,
        productUnits: state.units,
        itemType: itemType,
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
        itemType: itemType,
      );
    }
  }

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
    required String itemType,
  }) async {
    if (isClosed) return;
    emit(
      AddProductLoading(
        units: state.units,
        expiryDate: state.expiryDate,
      ),
    );

    try {
      final bool success = await productRepository.updateProduct(
        id: productId,
        name: name,
        barcode: barcode,
        totalStockQuantity: totalStockQuantity,
        expiryDate: expiryDate,
        batchNumber: batchNumber,
        size: size,
        color: color,
        productUnits: productUnits,
        itemType: itemType,
      );

      if (isClosed) return;

      if (success) {
        emit(
          AddProductSuccess(
            units: state.units,
            expiryDate: state.expiryDate,
          ),
        );
      } else {
        emit(
          AddProductError(
            "فشل تحديث المنتج في الخادم",
            units: state.units,
            expiryDate: state.expiryDate,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;
      emit(
        AddProductError(
          "حدث خطأ استثنائي: ${e.toString()}",
          units: state.units,
          expiryDate: state.expiryDate,
        ),
      );
    }
  }
}