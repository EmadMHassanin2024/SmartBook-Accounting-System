
import 'package:smart_book/features/inventory/auth_exports.dart';
class UnitItemCard extends StatefulWidget {
  final int index;
  final ProductUnitModel unit;
  final VoidCallback onDelete;
  final Function(String) onNameChanged;
  final Function(double) onSalePriceChanged;
  final Function(double) onPurchasePriceChanged;
  final Function(double) onFactorChanged;

  const UnitItemCard({
    super.key,
    required this.index,
    required this.unit,
    required this.onDelete,
    required this.onNameChanged,
    required this.onSalePriceChanged,
    required this.onPurchasePriceChanged,
    required this.onFactorChanged,
  });

  @override
  State<UnitItemCard> createState() => _UnitItemCardState();
}

class _UnitItemCardState extends State<UnitItemCard> {
  late final TextEditingController _nameController;
  late final TextEditingController _salePriceController;
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _factorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.unit.unitName);
    _salePriceController = TextEditingController(
      text: widget.unit.salePrice > 0 ? widget.unit.salePrice.toString() : "",
    );
    _purchasePriceController = TextEditingController(
      text: widget.unit.purchasePrice > 0 ? widget.unit.purchasePrice.toString() : "",
    );
    _factorController = TextEditingController(
      text: widget.unit.conversionFactor > 0 ? widget.unit.conversionFactor.toString() : "",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _salePriceController.dispose();
    _purchasePriceController.dispose();
    _factorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isBase = widget.unit.isBaseUnit;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBase ? AppColors.primaryBlue.withOpacity(0.05) : AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isBase ? AppColors.primaryBlue : AppColors.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  onChanged: widget.onNameChanged,
                  decoration: _inputDecoration(context.lang.unitNameHint),
                ),
              ),
              if (!isBase)
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _salePriceController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => widget.onSalePriceChanged(double.tryParse(val) ?? 0),
                  decoration: _inputDecoration(context.lang.salePrice),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _purchasePriceController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => widget.onPurchasePriceChanged(double.tryParse(val) ?? 0),
                  decoration: _inputDecoration(context.lang.purchasePrice),
                ),
              ),
            ],
          ),
          if (!isBase) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _factorController,
              keyboardType: TextInputType.number,
              onChanged: (val) => widget.onFactorChanged(double.tryParse(val) ?? 0),
              decoration: _inputDecoration(context.lang.conversionFactor),
            ),
          ]
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }
}