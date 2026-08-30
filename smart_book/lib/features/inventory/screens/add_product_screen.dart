import 'package:smart_book/features/inventory/auth_exports.dart';
import 'package:smart_book/features/inventory/extensions/inventory_extension_manager.dart';
import '../../system_config/logic/system_configuration_state.dart';
import '../widgets/product_reorder_section.dart';
import '../widgets/product_units_section.dart';


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
    _stockController = TextEditingController(text: "0");
    _reorderLevelController = TextEditingController(text: "5");

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
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  String _getCurrentActivityType(BuildContext context) {
    final activeModule = context.read<SystemConfigurationCubit>().state.settings.activeBusinessModule;
    return activeModule.name;
  }

  void _onSave(BuildContext context, AddProductState state) {
    if (_formKey.currentState!.validate()) {


      if (state.units.isEmpty) {
        _showSnackBar(
          context,
          "يرجى إضافة وحدة قياس",
          Colors.orange,
        );
        return;
      }

      final baseUnit = state.units.first;

      if (baseUnit.salePrice <= 0) {
        _showSnackBar(context, "يرجى تحديد سعر البيع للوحدة الأساسية أولاً", Colors.orange);
        return;
      }

      final currentActivityType = _getCurrentActivityType(context);

      context.read<AddProductCubit>().submitProduct(
        name: _nameController.text.trim(),
        barcode: _barcodeController.text.trim(),
        stock: int.tryParse(_stockController.text.trim()) ?? 0,
        expiryDate: _expiryDateController.text.trim().isNotEmpty ? _expiryDateController.text.trim() : null,
        batchNumber: _batchController.text.trim().isNotEmpty ? _batchController.text.trim() : null,
        isIngredient: _isIngredient,
        size: _sizeController.text.trim().isNotEmpty ? _sizeController.text.trim() : null,
        color: _colorController.text.trim().isNotEmpty ? _colorController.text.trim() : null,
        itemType: currentActivityType,
      );
    }
  }

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentActivityType = _getCurrentActivityType(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryBlue),
                ),
              );
            }
            else if (state is AddProductError) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              _showSnackBar(context, state.message, Colors.red);
            }
            else if (state is AddProductSuccess) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              _showSnackBar(context, "تم حفظ الصنف بنجاح وبدقة محاسبية! ✅", Colors.green);
              Navigator.pop(context, true);
            }
          },
        ),
      ],
      child: BlocBuilder<AddProductCubit, AddProductState>(
        builder: (context, state) {
          final units = state.units;
          final baseUnitName = units.isNotEmpty && units[0].unitName.trim().isNotEmpty
              ? units[0].unitName
              : "قطعة";

          return Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            appBar: AppBar(
              title: const Text("إضافة صنف جديد", style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionHeader("البيانات العامة", Icons.inventory_2),
                  BasicInfoCard(
                    nameController: _nameController,
                    barcodeController: _barcodeController,
                    stockController: _stockController,
                    baseUnitName: baseUnitName,
                  ),

                  const SizedBox(height: 12),
                  ProductReorderSection(reorderLevelController: _reorderLevelController),

                  const SizedBox(height: 16),
                  InventoryExtensionManager.getExtensionWidget(
                    activityType: currentActivityType,
                    expiryController: _expiryDateController,
                    batchController: _batchController,
                    onSelectExpiry: () => _selectExpiryDate(context),
                    isIngredient: _isIngredient,
                    onIsIngredientChanged: (val) => setState(() => _isIngredient = val ?? false),
                  ),

                  const SizedBox(height: 24),
                  ProductUnitsSection(units: units),

                  const SizedBox(height: 120),
                ],
              ),
            ),
            bottomSheet: _buildSaveButton(context, state),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, AddProductState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: ElevatedButton(
        onPressed: state is AddProductLoading ? null : () => _onSave(context, state),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          "تأكيد وحفظ الصنف",
          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}