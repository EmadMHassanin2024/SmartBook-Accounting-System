import 'package:smart_book/features/inventory/auth_exports.dart';

import '../../../../core/localization/language.dart';
import '../../../../core/widgets/app_text.dart';

class AddProductFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AddProductCubit cubit;
  final AddProductState addProductState;


  final TextEditingController nameController;
  final TextEditingController barcodeController;
  final TextEditingController stockController;
  final TextEditingController reorderLevelController;
  final TextEditingController expiryDateController;
  final TextEditingController batchController;
  final ValueNotifier<String?>? selectedUnitNotifier;

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
    this.selectedUnitNotifier,
  });

  @override
  Widget build(BuildContext context) {

    final List<String> unitKeys = [
      LanguageKeys.pieceKey,
      LanguageKeys.cartonKey,
      LanguageKeys.kgKey,
      LanguageKeys.literKey,
    ];

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(
            titleKey: LanguageKeys.basicInfoKey,
            icon: Icons.inventory_2,
          ),
          const SizedBox(height: 12),

          CustomTextFieldCard(
            labelTextKey: LanguageKeys.productNameKey,
            controller: nameController,
            icon: Icons.inventory_2_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return LanguageKeys.pleaseEnterItemNameKey;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          CustomTextFieldCard(
            labelTextKey: LanguageKeys.barcodeKey,
            controller: barcodeController,
            icon: Icons.qr_code,
          ),
          const SizedBox(height: 12),

          CustomTextFieldCard(
            labelTextKey: LanguageKeys.initialStockKey,
            controller: stockController,
            icon: Icons.format_list_numbered,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return LanguageKeys.pleaseEnterInitialStockKey;
              }
              if (double.tryParse(value.trim()) == null) {
                return LanguageKeys.pleaseEnterValidQuantityKey;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          CustomTextFieldCard(
            labelTextKey: LanguageKeys.reorderLevelKey,
            controller: reorderLevelController,
            icon: Icons.notifications_active_outlined,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                if (double.tryParse(value.trim()) == null) {
                  return LanguageKeys.pleaseEnterValidQuantityKey;
                }
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          InventoryExtensionManager.getExtensionWidget(
            expiryController: expiryDateController,
            batchController: batchController,
            onSelectExpiry: () => cubit.selectAndSetExpiryDate(context),
          ),

          const SizedBox(height: 15),


          const SectionHeader(
            titleKey: LanguageKeys.unitsAndPricesKey,
            icon: Icons.sell,
          ),
          const SizedBox(height: 2),

          ...addProductState.units.asMap().entries.map((entry) {
            final index = entry.key;
            final unit = entry.value;

            return Column(
              key: ValueKey('unit_card_$index'),
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: unit.unitName.isNotEmpty ? unit.unitName : null,
                      hint: const AppText(textKey: LanguageKeys.unitNameKey),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryBlue),
                      items: unitKeys.map((String key) {
                        final translatedName = context.translate(key);
                        return DropdownMenuItem<String>(
                          value: translatedName,
                          child: Text(translatedName),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          cubit.updateUnitData(index: index, name: newValue);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 2),

                // حقل سعر الشراء وسعر البيع
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldCard(
                        labelTextKey: LanguageKeys.purchasePriceKey,
                        controller: TextEditingController(text: unit.purchasePrice.toString()),
                        icon: Icons.money_off,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (val) => cubit.updateUnitData(
                          index: index,
                          purchasePrice: double.tryParse(val) ?? 0.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: CustomTextFieldCard(
                        labelTextKey: LanguageKeys.salePriceKey,
                        controller: TextEditingController(text: unit.salePrice.toString()),
                        icon: Icons.attach_money,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (val) => cubit.updateUnitData(
                          index: index,
                          salePrice: double.tryParse(val) ?? 0.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          }),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
