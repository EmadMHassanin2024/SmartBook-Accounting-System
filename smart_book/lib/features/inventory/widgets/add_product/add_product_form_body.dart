import 'package:smart_book/features/inventory/auth_exports.dart';
import '../../extensions/inventory_extension_manager.dart';



class AddProductFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController barcodeController;
  final TextEditingController stockController;
  final TextEditingController reorderLevelController;
  final TextEditingController expiryDateController;
  final TextEditingController batchController;
  final TextEditingController sizeController;
  final TextEditingController colorController;
  final bool isIngredient;
  final String currentActivityType;
  final VoidCallback onSelectExpiry;
  final ValueChanged<bool?> onIsIngredientChanged;

  const AddProductFormBody({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.barcodeController,
    required this.stockController,
    required this.reorderLevelController,
    required this.expiryDateController,
    required this.batchController,
    required this.sizeController,
    required this.colorController,
    required this.isIngredient,
    required this.currentActivityType,
    required this.onSelectExpiry,
    required this.onIsIngredientChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            title: context.lang.basicInfo,
            icon: Icons.inventory_2,
          ),
          BlocBuilder<AddProductCubit, AddProductState>(
            buildWhen: (previous, current) => previous.units != current.units,
            builder: (context, state) {
              final units = state.units;
              final baseUnitName = units.isNotEmpty &&
                  units.first.unitName.trim().isNotEmpty
                  ? units.first.unitName
                  : context.lang.baseUnit;

              return Column(
                children: [
                  BasicInfoCard(
                    nameController: nameController,
                    barcodeController: barcodeController,
                    stockController: stockController,
                    baseUnitName: baseUnitName,
                  ),
                  const SizedBox(height: 12),
                  ProductReorderSection(
                    reorderLevelController: reorderLevelController,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          InventoryExtensionManager.getExtensionWidget(
            activityType: currentActivityType,
            expiryController: expiryDateController,
            batchController: batchController,
            onSelectExpiry: onSelectExpiry,
            isIngredient: isIngredient,
            onIsIngredientChanged: onIsIngredientChanged,
          ),
          const SizedBox(height: 24),
          BlocBuilder<AddProductCubit, AddProductState>(
            buildWhen: (previous, current) => previous.units != current.units,
            builder: (context, state) {
              return ProductUnitsSection(units: state.units);
            },
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}