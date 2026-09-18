import 'package:smart_book/features/inventory/auth_exports.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/language_keys.dart';

class ProductReorderSection extends StatelessWidget {
  final TextEditingController reorderLevelController;

  const ProductReorderSection({
    super.key,
    required this.reorderLevelController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_outlined, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(

              context.translate(LanguageKeys.notifyWhenQuantityReachesKey),
              style: const TextStyle(fontSize: 14),

            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: TextFormField(
              controller: reorderLevelController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  if (double.tryParse(value.trim()) == null) {
                    return '';
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange.withOpacity(0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange.withOpacity(0.4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.orange, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}