import 'package:smart_book/features/inventory/auth_exports.dart';

class ProductBasicFieldsSection extends StatelessWidget {
  final BusinessModule selectedModule;
  final ValueChanged<BusinessModule?> onModuleChanged;
  final TextEditingController nameController;
  final TextEditingController barcodeController;
  final TextEditingController stockController;
  final TextEditingController reorderLevelController;

  const ProductBasicFieldsSection({
    super.key,
    required this.selectedModule,
    required this.onModuleChanged,
    required this.nameController,
    required this.barcodeController,
    required this.stockController,
    required this.reorderLevelController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          titleKey: LanguageKeys.basicInfoKey,
          icon: Icons.inventory_2,
        ),
        const SizedBox(height: 12),

        // 1. قائمة اختيار النشاط التابع له الصنف
        DropdownButtonFormField<BusinessModule>(
          value: selectedModule,
          decoration: InputDecoration(
            label: const AppText(textKey: LanguageKeys.businessModuleKey),
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
          onChanged: onModuleChanged,
        ),
        const SizedBox(height: 12),

        // 2. اسم الصنف
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

        // 4. الرصيد الافتتاحي
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
      ],
    );
  }
}