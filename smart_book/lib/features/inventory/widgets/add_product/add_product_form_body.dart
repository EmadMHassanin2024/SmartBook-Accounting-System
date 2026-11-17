import 'package:smart_book/features/inventory/auth_exports.dart';

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
  final ValueNotifier<String?> selectedUnitNotifier;
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
    required this.selectedUnitNotifier,
    required this.selectedBusinessModuleNotifier,
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
      child: ValueListenableBuilder<String>(
        valueListenable: selectedBusinessModuleNotifier,
        builder: (context, currentModule, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SectionHeader(
                titleKey: LanguageKeys.basicInfoKey,
                icon: Icons.inventory_2,
              ),
              const SizedBox(height: 12),

              // 1. قائمة اختيار النشاط التابع له الصنف
              DropdownButtonFormField<BusinessModule>(
                initialValue: BusinessModule.values.firstWhere(
                      (m) => m.name == currentModule,
                  orElse: () => BusinessModule.pharmacy,
                ),
                decoration: InputDecoration(
                  // يمكنك استبدال النص بمفتاح ترجمة مثل: context.translate(LanguageKeys.businessModuleKey)
                  labelText: "النشاط التابع له الصنف",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: BusinessModule.values.map((module) {
                  return DropdownMenuItem<BusinessModule>(
                    value: module,
                    child: Text(module.arabicName),
                  );
                }).toList(),
                onChanged: (BusinessModule? newModule) {
                  if (newModule != null) {
                    selectedBusinessModuleNotifier.value = newModule.name;
                  }
                },
              ),
              const SizedBox(height: 12),

              // 2. اسم الصنف (مع ترجمة رسالة التحقق)
              CustomTextFieldCard(
                labelTextKey: LanguageKeys.productNameKey,
                controller: nameController,
                icon: Icons.inventory_2_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.translate(LanguageKeys.pleaseEnterItemNameKey);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 3. الباركود
              CustomTextFieldCard(
                labelTextKey: LanguageKeys.barcodeKey,
                controller: barcodeController,
                icon: Icons.qr_code,
              ),
              const SizedBox(height: 12),

              // 4. الرصيد الافتتاحي (مع ترجمة رسائل التحقق)
              CustomTextFieldCard(
                labelTextKey: LanguageKeys.initialStockKey,
                controller: stockController,
                icon: Icons.format_list_numbered,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.translate(LanguageKeys.pleaseEnterInitialStockKey);
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return context.translate(LanguageKeys.pleaseEnterValidQuantityKey);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 5. حد إعادة الطلب
              CustomTextFieldCard(
                labelTextKey: LanguageKeys.reorderLevelKey,
                controller: reorderLevelController,
                icon: Icons.notifications_active_outlined,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (double.tryParse(value.trim()) == null) {
                      return context.translate(LanguageKeys.pleaseEnterValidQuantityKey);
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 6. الحقول الديناميكية الخاصة بالنشاط
              InventoryExtensionManager.getExtensionWidget(
                activityType: currentModule,
                expiryController: expiryDateController,
                batchController: batchController,
                onSelectExpiry: () => cubit.selectAndSetExpiryDate(context),
              ),

              const SizedBox(height: 15),

              // 7. الأسعار والوحدات
              const SectionHeader(
                titleKey: LanguageKeys.unitsAndPricesKey,
                icon: Icons.sell,
              ),
              const SizedBox(height: 8),

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
                          // الآن القيمة المخزنة هي المفتاح (key)، فتتطابق دائماً مع القائمة
                          value: unitKeys.contains(unit.unitName) ? unit.unitName : null,
                          hint: const AppText(textKey: LanguageKeys.unitNameKey),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryBlue),
                          items: unitKeys.map((String key) {
                            return DropdownMenuItem<String>(
                              value: key, // نخزن المفتاح الثابت
                              child: AppText(textKey: key), // نعرض النص المترجم
                            );
                          }).toList(),
                          onChanged: (String? newKey) {
                            if (newKey != null) {
                              cubit.updateUnitData(index: index, name: newKey);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFieldCard(
                            labelTextKey: LanguageKeys.purchasePriceKey,
                            initialValue: unit.purchasePrice == 0.0 ? '' : unit.purchasePrice.toString(),
                            icon: Icons.money_off,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (val) => cubit.updateUnitData(
                              index: index,
                              purchasePrice: double.tryParse(val) ?? 0.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextFieldCard(
                            labelTextKey: LanguageKeys.salePriceKey,
                            initialValue: unit.salePrice == 0.0 ? '' : unit.salePrice.toString(),
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
          );
        },
      ),
    );
  }
}