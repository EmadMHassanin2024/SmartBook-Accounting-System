import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AddProductCubit cubit;
  final AddProductState addProductState;
  final String currentActivityType;

  // تمرير الـ Controllers من الخارج لكي يتم التحكم بها من الـ Parent State
  final TextEditingController nameController;
  final TextEditingController barcodeController;
  final TextEditingController stockController;
  final TextEditingController reorderLevelController;
  final TextEditingController expiryDateController;
  final TextEditingController batchController;
  final TextEditingController sizeController;
  final TextEditingController colorController;

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
  });

  @override
  Widget build(BuildContext context) {
    // ✅ تمرير جميع الـ Controllers واستقبالها بشكل سليم في الـ AddProductFormBody
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
      // إذا كان AddProductFormBody يدعم المقاس واللون أيضاً، يمكنك تمريرهم هكذا:
      // sizeController: sizeController,
      // colorController: colorController,
    );
  }
}