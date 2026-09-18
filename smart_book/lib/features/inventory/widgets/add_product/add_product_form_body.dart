import 'package:smart_book/features/inventory/widgets/add_product/product_reorder_section.dart';
import 'package:smart_book/features/inventory/widgets/add_product/product_units_section.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/language_keys.dart';
import '../../../../core/packages.dart';
import '../../../../core/utils/extensions/localization_extension.dart';

import '../../extensions/inventory_extension_manager.dart';
import '../../logic/add_product_cubit.dart';
import '../../logic/add_product_state.dart';
import '../common/custom_text_field_card.dart';
import '../common/section_header_widget.dart';

class AddProductFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AddProductCubit cubit;
  final AddProductState addProductState;
  final String currentActivityType; // إذا احتجتها هنا، أو جلبناها من الـ cubit

  const AddProductFormBody({
    super.key,
    required this.formKey,
    required this.cubit,
    required this.addProductState,
    required this.currentActivityType,
  });

  @override
  Widget build(BuildContext context) {
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
          // استخدام الـ controllers مباشرة من الـ cubit
          CustomTextFieldCard(
            labelTextKey: LanguageKeys.productNameKey,

            controller: cubit.nameController,
            icon: Icons.inventory_2_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.translate(LanguageKeys.pleaseEnterItemNameKey);
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomTextFieldCard(
            labelTextKey: LanguageKeys.barcodeKey,

            controller: cubit.barcodeController,
            icon: Icons.qr_code,
          ),
          const SizedBox(height: 12),
          CustomTextFieldCard(
            labelTextKey: LanguageKeys.initialStockKey,

            controller: cubit.stockController,
            icon: Icons.format_list_numbered,
            keyboardType: TextInputType.number,

            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.lang.pleaseEnterInitialStock; // أو رسالة الحقل المطلوبة
              }
              if (double.tryParse(value.trim()) == null) {
                return context.lang.pleaseEnterValidQuantity;
              }
              return null;
            },

          ),
          const SizedBox(height: 12),
          //حد إعادة الطلب
          ProductReorderSection(
            reorderLevelController: cubit.reorderLevelController,
          ),


          const SizedBox(height: 16),

          InventoryExtensionManager.getExtensionWidget(
            activityType: currentActivityType,
            expiryController: cubit.expiryDateController,
            batchController: cubit.batchController,
            onSelectExpiry: () => cubit.selectExpiryDate(context),
            isIngredient: addProductState.isIngredient,
            onIsIngredientChanged: (value) {
              cubit.changeIngredientStatus(value ?? false);
            },
          ),


          const SizedBox(height: 24),

          ProductUnitsSection(units: addProductState.units),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}