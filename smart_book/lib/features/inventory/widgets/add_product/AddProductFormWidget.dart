import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AddProductCubit cubit;
  final AddProductState addProductState;
  final String currentActivityType;

  final TextEditingController nameController;
  final TextEditingController barcodeController;
  final TextEditingController stockController;
  final TextEditingController reorderLevelController;
  final TextEditingController expiryDateController;
  final TextEditingController batchController;
  final TextEditingController sizeController;
  final TextEditingController colorController;
  final ValueNotifier<String> selectedBusinessModuleNotifier;
  final ValueNotifier<String?> selectedUnitNotifier; // ✅ تمت إضافته ليتطابق مع الـ Body

  const AddProductFormWidget({
    super.key,
    required this.formKey,
    required this.cubit,
    required this.addProductState,
    required this.currentActivityType,
    required this.nameController,
    required this.barcodeController,
    required this.stockController,
    required this.reorderLevelController,
    required this.expiryDateController,
    required this.batchController,
    required this.sizeController,
    required this.colorController,
    required this.selectedBusinessModuleNotifier,
    required this.selectedUnitNotifier, // ✅ متطلب إلزامي
  });

  @override
  Widget build(BuildContext context) {
    return AddProductFormBody(
      formKey: formKey,
      cubit: cubit,
      addProductState: addProductState,
      nameController: nameController,
      barcodeController: barcodeController,
      stockController: stockController,
      reorderLevelController: reorderLevelController,
      expiryDateController: expiryDateController,
      batchController: batchController,
      selectedBusinessModuleNotifier: selectedBusinessModuleNotifier,

    );
  }
}