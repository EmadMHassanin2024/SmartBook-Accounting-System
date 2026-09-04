import 'package:smart_book/features/inventory/auth_exports.dart';
import 'package:smart_book/features/inventory/extensions/inventory_extension_manager.dart';
import '../../../core/utils/extensions/localization_extension.dart';
import '../../system_config/logic/system_configuration_state.dart';
import '../widgets/product_reorder_section.dart';
import '../widgets/product_units_section.dart';
import '../widgets/product_save_bottom_sheet.dart';
import '../widgets/section_header_widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

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

    _nameController = TextEditingController();
    _barcodeController = TextEditingController();
    _stockController = TextEditingController(text: '0');
    _reorderLevelController = TextEditingController(text: '5');
    _expiryDateController = TextEditingController();
    _batchController = TextEditingController();
    _sizeController = TextEditingController();
    _colorController = TextEditingController();
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
      '${picked.year}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
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

  void _onSave(BuildContext context, AddProductState state) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (state.units.isEmpty) {
      _showSnackBar(
        context,
        context.lang.pleaseAddUnit,
        Colors.orange,
      );
      return;
    }

    final baseUnit = state.units.first;

    if (baseUnit.salePrice <= 0) {
      _showSnackBar(
        context,
        context.lang.pleaseSetBaseSalePrice,
        Colors.orange,
      );
      return;
    }

    context.read<AddProductCubit>().submitProduct(
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.trim(),
      stock: int.tryParse(
        _stockController.text.trim(),
      ) ??
          0,
      expiryDate: _expiryDateController.text.trim().isNotEmpty
          ? _expiryDateController.text.trim()
          : null,
      batchNumber: _batchController.text.trim().isNotEmpty
          ? _batchController.text.trim()
          : null,
      isIngredient: _isIngredient,
      size: _sizeController.text.trim().isNotEmpty
          ? _sizeController.text.trim()
          : null,
      color: _colorController.text.trim().isNotEmpty
          ? _colorController.text.trim()
          : null,
      itemType: _getCurrentActivityType(context),
    );
  }

  void _showSnackBar(
      BuildContext context,
      String message,
      Color color,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state is AddProductLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            ),
          );
        } else if (state is AddProductError) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          _showSnackBar(
            context,
            state.message,
            Colors.red,
          );
        } else if (state is AddProductSuccess) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          _showSnackBar(
            context,
            context.lang.saveSuccess,
            Colors.green,
          );

          Navigator.pop(context, true);
        }
      },
      child: BlocBuilder<
          SystemConfigurationCubit,
          SystemConfigurationState>(
        buildWhen: (previous, current) =>
        previous.settings.activeBusinessModule !=
            current.settings.activeBusinessModule,
        builder: (context, configState) {
          final currentActivityType =
              configState.settings.activeBusinessModule.name;

          return Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            appBar: AppBar(
              title: Text(
                context.lang.addProduct,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SectionHeader(
                    title: context.lang.basicInfo,
                    icon: Icons.inventory_2,
                  ),
                  BlocBuilder<AddProductCubit, AddProductState>(
                    buildWhen: (previous, current) =>
                    previous.units != current.units,
                    builder: (context, state) {
                      final units = state.units;

                      final baseUnitName =
                      units.isNotEmpty &&
                          units.first.unitName.trim().isNotEmpty
                          ? units.first.unitName
                          : context.lang.baseUnit;

                      return Column(
                        children: [
                          BasicInfoCard(
                            nameController: _nameController,
                            barcodeController: _barcodeController,
                            stockController: _stockController,
                            baseUnitName: baseUnitName,
                          ),
                          const SizedBox(height: 12),
                          ProductReorderSection(
                            reorderLevelController:
                            _reorderLevelController,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  InventoryExtensionManager.getExtensionWidget(
                    activityType: currentActivityType,
                    expiryController: _expiryDateController,
                    batchController: _batchController,
                    onSelectExpiry: () =>
                        _selectExpiryDate(context),
                    isIngredient: _isIngredient,
                    onIsIngredientChanged: (value) {
                      setState(() {
                        _isIngredient = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AddProductCubit, AddProductState>(
                    buildWhen: (previous, current) =>
                    previous.units != current.units,
                    builder: (context, state) {
                      return ProductUnitsSection(
                        units: state.units,
                      );
                    },
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
            bottomSheet: ProductSaveBottomSheet(
              onSavePressed: () {
                final state =
                    context.read<AddProductCubit>().state;

                _onSave(context, state);
              },
            ),
          );
        },
      ),
    );
  }
}