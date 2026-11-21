import 'package:smart_book/features/inventory/auth_exports.dart';

import '../inventory_list/product_basic_fields_section.dart';
import '../inventory_list/product_unit_item_card.dart';

class AddProductFormBody extends StatelessWidget {
  static const List<String> unitKeys = [
    LanguageKeys.pieceKey,
    LanguageKeys.cartonKey,
    LanguageKeys.kgKey,
    LanguageKeys.literKey,
  ];

  final GlobalKey<FormState> formKey;
  final AddProductCubit cubit;
  final AddProductState addProductState;

  final TextEditingController nameController;
  final TextEditingController barcodeController;
  final TextEditingController stockController;
  final TextEditingController reorderLevelController;
  final TextEditingController expiryDateController;
  final TextEditingController batchController;

  final ValueNotifier<String> selectedBusinessModuleNotifier;

  const AddProductFormBody({
    super.key,
    required this.formKey,
    required this.cubit,
    required this.addProductState,
    required this.nameController,
    required this.barcodeController,
    required this.stockController,
    required this.reorderLevelController,
    required this.expiryDateController,
    required this.batchController,
    required this.selectedBusinessModuleNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ValueListenableBuilder<String>(
        valueListenable: selectedBusinessModuleNotifier,
        builder: (context, currentModule, child) {
          final selectedModule = BusinessModule.values.firstWhere(
                (m) => m.name == currentModule,
            orElse: () => BusinessModule.pharmacy,
          );

          final units = addProductState.units;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3 + units.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ProductBasicFieldsSection(
                  selectedModule: selectedModule,
                  onModuleChanged: (BusinessModule? newModule) {
                    if (newModule != null) {
                      selectedBusinessModuleNotifier.value = newModule.name;
                    }
                  },
                  nameController: nameController,
                  barcodeController: barcodeController,
                  stockController: stockController,
                  reorderLevelController: reorderLevelController,
                );
              }

              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 15),
                  child: InventoryExtensionManager.getExtensionWidget(
                    activityType: currentModule,
                    expiryController: expiryDateController,
                    batchController: batchController,
                    onSelectExpiry: () => cubit.selectAndSetExpiryDate(context),
                  ),
                );
              }

              if (index == 2) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: SectionHeader(
                    titleKey: LanguageKeys.unitsAndPricesKey,
                    icon: Icons.sell,
                  ),
                );
              }

              final unitIndex = index - 3;
              if (unitIndex < units.length) {
                final unit = units[unitIndex];
                return ProductUnitItemCard(
                  key: ValueKey('unit_$unitIndex'),
                  index: unitIndex,
                  unit: unit,
                  unitKeys: unitKeys,
                  cubit: cubit,
                );
              }

              return const SizedBox(height: 120);
            },
          );
        },
      ),
    );
  }
}