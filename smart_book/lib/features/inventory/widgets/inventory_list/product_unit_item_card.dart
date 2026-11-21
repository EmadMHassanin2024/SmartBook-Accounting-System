import 'package:smart_book/features/inventory/auth_exports.dart';

class ProductUnitItemCard extends StatelessWidget {
  final int index;
  final dynamic unit;
  final List<String> unitKeys;
  final AddProductCubit cubit;

  const ProductUnitItemCard({
    super.key,
    required this.index,
    required this.unit,
    required this.unitKeys,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
              value: unitKeys.contains(unit.unitName) ? unit.unitName : null,
              hint: const AppText(textKey: LanguageKeys.unitNameKey),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primaryBlue,
              ),
              items: unitKeys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: AppText(textKey: key),
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
                initialValue: unit.purchasePrice == 0.0
                    ? ''
                    : unit.purchasePrice.toString(),
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
                initialValue:
                unit.salePrice == 0.0 ? '' : unit.salePrice.toString(),
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
  }
}