
import 'package:smart_book/features/inventory/auth_exports.dart';


class ProductFormHelper {
  static void handleSaveProcess({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required AddProductState state,
    required ProductModel? productToEdit,
    required TextEditingController nameController,
    required TextEditingController barcodeController,
    required TextEditingController stockController,
    required TextEditingController expiryDateController,
    required TextEditingController batchController,
    required TextEditingController sizeController,
    required TextEditingController colorController,
    required bool isIngredient,
    required String activityType,
  }) {
    if (!formKey.currentState!.validate()) return;

    if (state.units.isEmpty) {
      _showSnackBar(context, context.lang.pleaseAddUnit, Colors.orange);
      return;
    }

    if (state.units.first.salePrice <= 0) {
      _showSnackBar(context, context.lang.pleaseSetBaseSalePrice, Colors.orange);
      return;
    }

    final cubit = context.read<AddProductCubit>();
    final isEditing = productToEdit != null;

    if (isEditing) {
      cubit.updateProduct(
        productId: productToEdit.id,
        name: nameController.text.trim(),
        barcode: barcodeController.text.trim(),
        totalStockQuantity: double.tryParse(stockController.text.trim()) ?? 0.0,
        expiryDate: _getTrimmedText(expiryDateController),
        batchNumber: _getTrimmedText(batchController),
        isIngredient: isIngredient,
        size: _getTrimmedText(sizeController),
        color: _getTrimmedText(colorController),
        itemType: activityType,
        productUnits: state.units,
      );
    } else {
      cubit.submitProduct(
        name: nameController.text.trim(),
        barcode: barcodeController.text.trim(),
        stock: double.tryParse(stockController.text.trim()) ?? 0.0,
        expiryDate: _getTrimmedText(expiryDateController),
        batchNumber: _getTrimmedText(batchController),
        isIngredient: isIngredient,
        size: _getTrimmedText(sizeController),
        color: _getTrimmedText(colorController),
        itemType: activityType,
      );
    }
  }

  static String? _getTrimmedText(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isNotEmpty ? text : null;
  }

  static void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}