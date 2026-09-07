import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductScreen extends StatelessWidget {
  final ProductModel? productToEdit;
  AddProductScreen({super.key, this.productToEdit});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _reorderLevelController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  bool get _isEditing => productToEdit != null;

  void _initializeControllers(AddProductCubit cubit) {
    final p = productToEdit;
    if (p == null) {
      _reorderLevelController.text = '5';
      return;
    }
    _nameController.text = p.name;
    _barcodeController.text = p.barcode ?? '';
    _stockController.text = p.stock.toString();
    _reorderLevelController.text = '5';
    _expiryDateController.text = p.expiryDate ?? '';
    _batchController.text = p.batchNumber ?? '';
    _sizeController.text = p.size ?? '';
    _colorController.text = p.color ?? '';

    if (p.units.isNotEmpty) {
      cubit.setInitialUnits(p.units);
    }
    if (p.isIngredient) {
      cubit.changeIngredientStatus(true);
    }
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    final formattedDate = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    _expiryDateController.text = formattedDate;

    // تحديث الحالة عبر الـ Cubit بدلاً من setState
    context.read<AddProductCubit>().setExpiryDate(formattedDate);
  }

  String? _getOptionalText(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  void _onSave(BuildContext context, AddProductState state, String activityType) {
    if (!_formKey.currentState!.validate()) return;

    if (state.units.isEmpty) {
      SnackbarHelper.show(context.lang.pleaseAddUnit, const Color(0xFFFFB300), icon: Icons.warning_amber_rounded);
      return;
    }

    if (state.units.first.salePrice <= 0) {
      SnackbarHelper.show(context.lang.pleaseSetBaseSalePrice, const Color(0xFFFFB300), icon: Icons.warning_amber_rounded);
      return;
    }

    final cubit = context.read<AddProductCubit>();
    final name = _nameController.text.trim();
    final barcode = _barcodeController.text.trim();
    final stock = double.tryParse(_stockController.text.trim()) ?? 0.0;
    final expiry = _getOptionalText(_expiryDateController);
    final batch = _getOptionalText(_batchController);
    final size = _getOptionalText(_sizeController);
    final color = _getOptionalText(_colorController);

    if (_isEditing) {
      cubit.updateProductData(
        productId: productToEdit!.id,
        name: name,
        barcode: barcode,
        totalStockQuantity: stock,
        expiryDate: expiry,
        batchNumber: batch,
        isIngredient: state.isIngredient,
        size: size,
        color: color,
        itemType: activityType,
        units: state.units,
      );
    } else {
      cubit.submitProductData(
        name: name,
        barcode: barcode,
        stock: stock,
        expiryDate: expiry,
        batchNumber: batch,
        isIngredient: state.isIngredient,
        size: size,
        color: color,
        itemType: activityType,
      );
    }
  }

  void _handleBlocListenerState(BuildContext context, AddProductState state) {
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

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddProductCubit>();
    _initializeControllers(cubit);

    return BlocListener<AddProductCubit, AddProductState>(
      listener: _handleBlocListenerState,
      child: BlocBuilder<SystemConfigurationCubit, SystemConfigurationState>(
        buildWhen: (previous, current) =>
        previous.settings.activeBusinessModule !=
            current.settings.activeBusinessModule,
        builder: (context, configState) {
          final currentActivityType =
              configState.settings.activeBusinessModule.name;

          return BlocBuilder<AddProductCubit, AddProductState>(
            builder: (context, addProductState) {
              return Scaffold(
                backgroundColor: AppColors.scaffoldBg,
                appBar: AddProductAppBar(
                  isEditing: _isEditing,
                  addProductTitle: context.lang.addProduct,
                ),
                body: AddProductFormBody(
                  formKey: _formKey,
                  nameController: _nameController,
                  barcodeController: _barcodeController,
                  stockController: _stockController,
                  reorderLevelController: _reorderLevelController,
                  expiryDateController: _expiryDateController,
                  batchController: _batchController,
                  sizeController: _sizeController,
                  colorController: _colorController,
                  isIngredient: addProductState.isIngredient,
                  currentActivityType: currentActivityType,
                  onSelectExpiry: () => _selectExpiryDate(context),
                  onIsIngredientChanged: (value) {
                    cubit.changeIngredientStatus(value ?? false);
                  },
                ),
                bottomSheet: ProductSaveBottomSheet(
                  onSavePressed: () {
                    _onSave(context, addProductState, currentActivityType);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}