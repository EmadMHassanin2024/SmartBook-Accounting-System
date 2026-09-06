import 'package:smart_book/features/inventory/auth_exports.dart';


class ProductUnitsSection extends StatelessWidget {
  final List<ProductUnitModel> units;

  const ProductUnitsSection({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context.lang.unitsAndPrices, Icons.sell),
        ...units.asMap().entries.map((entry) {
          final index = entry.key;
          final unit = entry.value;
          return UnitItemCard(
            key: ValueKey('unit_item_$index'),
            index: index,
            unit: unit,
            onDelete: () => context.read<AddProductCubit>().removeUnit(index),
            onNameChanged: (val) => context.read<AddProductCubit>().updateUnitData(index: index, name: val),
            onSalePriceChanged: (val) => context.read<AddProductCubit>().updateUnitData(index: index, salePrice: val),
            onPurchasePriceChanged: (val) => context.read<AddProductCubit>().updateUnitData(index: index, purchasePrice: val),
            onFactorChanged: (val) => context.read<AddProductCubit>().updateUnitData(index: index, conversionFactor: val),
          );
        }),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.read<AddProductCubit>().addUnit(),
          icon: const Icon(Icons.add),
          label: Text(context.lang.addAnotherUnit),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
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
}