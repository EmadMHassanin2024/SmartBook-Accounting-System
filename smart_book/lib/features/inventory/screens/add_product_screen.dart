import 'package:smart_book/features/inventory/auth_exports.dart';



class AddProductScreen extends StatefulWidget {
  final ProductModel? productToEdit;
  const AddProductScreen({super.key, this.productToEdit});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _stockController;
  late final TextEditingController _reorderLevelController;
  late final TextEditingController _expiryDateController;
  late final TextEditingController _batchController;
  late final TextEditingController _sizeController;
  late final TextEditingController _colorController;

  bool _isIngredient = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeInitialUnits();
  }

  void _initializeControllers() {
    final p = widget.productToEdit;
    _nameController = TextEditingController(text: p?.name ?? '');
    _barcodeController = TextEditingController(text: p?.barcode ?? '');
    _stockController = TextEditingController(text: p?.stock.toString() ?? '0');
    _reorderLevelController = TextEditingController(text: '5');
    _expiryDateController = TextEditingController(text: p?.expiryDate ?? '');
    _batchController = TextEditingController(text: p?.batchNumber ?? '');
    _sizeController = TextEditingController(text: p?.size ?? '');
    _colorController = TextEditingController(text: p?.color ?? '');
    _isIngredient = p?.isIngredient ?? false;
  }

  void _initializeInitialUnits() {
    final p = widget.productToEdit;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (p != null && p.units.isNotEmpty) {
        context.read<AddProductCubit>().setInitialUnits(p.units);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _stockController.dispose();
    _reorderLevelController.dispose();
    _expiryDateController.dispose();
    _batchController.dispose();
    _sizeController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (!mounted || picked == null) return;

    setState(() {
      _expiryDateController.text =
      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    });
  }

  String _getCurrentActivityType(BuildContext context) {
    return context
        .read<SystemConfigurationCubit>()
        .state
        .settings
        .activeBusinessModule
        .name;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    } else if (state is AddProductSuccess) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.lang.saveSuccess), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;

    return BlocListener<AddProductCubit, AddProductState>(
      listener: _handleBlocListenerState,
      child: BlocBuilder<SystemConfigurationCubit, SystemConfigurationState>(
        buildWhen: (previous, current) =>
        previous.settings.activeBusinessModule !=
            current.settings.activeBusinessModule,
        builder: (context, configState) {
          final currentActivityType =
              configState.settings.activeBusinessModule.name;

          return Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            appBar: AddProductAppBar(
              isEditing: isEditing,
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
              isIngredient: _isIngredient,
              currentActivityType: currentActivityType,
              onSelectExpiry: () => _selectExpiryDate(context),
              onIsIngredientChanged: (value) {
                setState(() {
                  _isIngredient = value ?? false;
                });
              },
            ),
            bottomSheet: ProductSaveBottomSheet(
              onSavePressed: () {
                final state = context.read<AddProductCubit>().state;

                // ✅ استدعاء الهيلبر الخارجي لتنفيذ الحفظ بأسلوب Clean Code
                ProductFormHelper.handleSaveProcess(
                  context: context,
                  formKey: _formKey,
                  state: state,
                  productToEdit: widget.productToEdit,
                  nameController: _nameController,
                  barcodeController: _barcodeController,
                  stockController: _stockController,
                  expiryDateController: _expiryDateController,
                  batchController: _batchController,
                  sizeController: _sizeController,
                  colorController: _colorController,
                  isIngredient: _isIngredient,
                  activityType: _getCurrentActivityType(context),
                );
              },
            ),
          );
        },
      ),
    );
  }
}