
import 'package:smart_book/features/inventory/auth_exports.dart';


class ProductReorderSection extends StatelessWidget {
  final TextEditingController reorderLevelController;

  const ProductReorderSection({super.key, required this.reorderLevelController});

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
          Expanded(child: Text(context.lang.notifyWhenQuantityReaches)),
          SizedBox(
            width: 60,
            child: TextFormField(
              controller: reorderLevelController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(isDense: true),
            ),
          ),
        ],
      ),
    );
  }
}