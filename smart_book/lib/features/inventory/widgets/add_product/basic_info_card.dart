
import 'package:smart_book/features/inventory/auth_exports.dart';

class BasicInfoCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController barcodeController;
  final TextEditingController stockController;
  final String baseUnitName;

  const BasicInfoCard({
    super.key,
    required this.nameController,
    required this.barcodeController,
    required this.stockController,
    required this.baseUnitName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(
            context.lang.basicInformation,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context.lang.itemNameHint,
            nameController,
            Icons.shopping_bag_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.lang.pleaseEnterItemName;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            context.lang.barcodeOptional,
            barcodeController,
            Icons.qr_code_scanner,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            "${context.lang.openingQuantity} ($baseUnitName)",
            stockController,
            Icons.inventory_2_outlined,
            isNumber: true,
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                if (double.tryParse(value.trim()) == null) {
                  return context.lang.pleaseEnterValidQuantity;
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String hint,
      TextEditingController controller,
      IconData icon, {
        bool isNumber = false,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        prefixIcon: Icon(icon, size: 20, color: AppColors.iconGrey),
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}