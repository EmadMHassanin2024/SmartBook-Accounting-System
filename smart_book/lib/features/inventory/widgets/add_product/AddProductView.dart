import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductView extends StatefulWidget {
  final ProductModel? productToEdit;
  const AddProductView({super.key, this.productToEdit});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // تعريف الـ Controllers للحقول النصية
  late final TextEditingController nameController;
  late final TextEditingController barcodeController;
  late final TextEditingController stockController;
  late final TextEditingController reorderLevelController;
  late final TextEditingController expiryDateController;
  late final TextEditingController batchController;
  late final TextEditingController sizeController;
  late final TextEditingController colorController;
  late final ValueNotifier<String?> selectedUnitNotifier;

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;

    nameController = TextEditingController(text: p?.name ?? '');
    barcodeController = TextEditingController(text: p?.barcode ?? '');
    stockController = TextEditingController(text: p?.stock.toString() ?? '0');
    reorderLevelController = TextEditingController(text: p?.reorderLevel?.toString() ?? '');
    expiryDateController = TextEditingController(text: p?.expiryDate ?? '');
    batchController = TextEditingController(text: p?.batchNumber ?? '');
    sizeController = TextEditingController(text: p?.size ?? '');
    colorController = TextEditingController(text: p?.color ?? '');
    selectedUnitNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    nameController.dispose();
    barcodeController.dispose();
    stockController.dispose();
    reorderLevelController.dispose();
    expiryDateController.dispose();
    batchController.dispose();
    sizeController.dispose();
    colorController.dispose();
    selectedUnitNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddProductCubit>();

    final bool isEditing = widget.productToEdit != null;

    return
        BlocListener<AddProductCubit, AddProductState>(
      listener: (context, state) {
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
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          SnackbarHelper.showSuccess(LanguageKeys.saveSuccessKey);
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AddProductAppBar(
          isEditing: isEditing,
          addProductTitleKey: LanguageKeys.addProductKey,
          actions: const [
            SizedBox(width: 16),
          ],
          textKey: '',
        ),

        body:BlocBuilder<AddProductCubit, AddProductState>(
    builder: (context, state) {
    final cubit = context.read<AddProductCubit>();
    return AddProductFormBody(
          formKey: formKey,
          cubit: cubit,
          addProductState: state,
          nameController: nameController,
          barcodeController: barcodeController,
          stockController: stockController,
          reorderLevelController: reorderLevelController,
          expiryDateController: expiryDateController,
          batchController: batchController,
          selectedUnitNotifier: selectedUnitNotifier,

    );
    },
    ),
        bottomSheet: ProductSaveBottomSheet(

          onSavePressed: () {
            if (!formKey.currentState!.validate()) return;
            cubit.onSave(

              context: context,

                name: InputHelper.getCleanText(nameController),
                barcode: InputHelper.getCleanText(barcodeController),
                stock: InputHelper.parseDouble(stockController),
              expiryDate: InputHelper.getOptionalText(expiryDateController),
              batchNumber: InputHelper.getOptionalText(batchController),
              size: InputHelper.getOptionalText(sizeController),
              color: InputHelper.getOptionalText(colorController),
            );
          },
        ),
      ),
    );
  }
}