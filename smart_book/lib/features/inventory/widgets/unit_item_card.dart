import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../models/ ProductUnitModel.dart';
//عرض وحدة منتج واحدة داخل فاتورة أو شاشة إدارة المنتجات.
class UnitItemCard extends StatelessWidget {
  final int index;
  final ProductUnitModel unit;
  final VoidCallback onDelete;
  final Function(String) onNameChanged;
  final Function(double) onSalePriceChanged;
  final Function(double) onPurchasePriceChanged;
  // Callback عند تغيير معامل التحويل
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
  Widget build(BuildContext context) {
    bool isBase = unit.isBaseUnit;
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
                child: _buildSmallTextField(
                  "اسم الوحدة (قطعة، كرتونة..)",
                  onNameChanged,
                  initialValue: unit.unitName,
                ),
              ),
              if (!isBase)
                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // ... داخل كلاس UnitItemCard
              Expanded(
                child: _buildSmallTextField(
                  "سعر البيع",
                      (val) => onSalePriceChanged(double.tryParse(val) ?? 0),
                  isNumber: true,
                  // تأكد من استخدام unit.salePrice هنا
                  initialValue: unit.salePrice > 0 ? unit.salePrice.toString() : "",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSmallTextField(
                  "سعر الشراء",
                      (val) => onPurchasePriceChanged(double.tryParse(val) ?? 0),
                  isNumber: true,
                  initialValue: unit.purchasePrice > 0 ? unit.purchasePrice.toString() : "",
                ),
              ),
            ],
          ),
          if (!isBase) ...[
            const SizedBox(height: 12),
            _buildSmallTextField(
              "عامل التحويل (كم قطعة في هذه الوحدة؟)",
                  (val) => onFactorChanged(double.tryParse(val) ?? 1),
              isNumber: true,
              initialValue: unit.conversionFactor.toString(),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildSmallTextField(String hint, Function(String) onChanged, {bool isNumber = false, String? initialValue}) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
    );
  }
}