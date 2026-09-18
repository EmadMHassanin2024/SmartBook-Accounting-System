import 'package:smart_book/features/inventory/auth_exports.dart';
import '../../../../core/localization/language_keys.dart';
import '../common/filter_option_tile.dart';

class InventoryFilterSheet extends StatelessWidget {
  final Function(String) onFilterSelected;

  const InventoryFilterSheet({super.key, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              context.lang.filterByInventoryStatus,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 5),

          // خيار الكل
          FilterOptionTile(
            displayTitle:LanguageKeys.allCategoryKey,
            icon: Icons.inventory_2_outlined,
            color: AppColors.primaryBlue,
            onTap: () {
              onFilterSelected(LanguageKeys.allCategoryKey);
              Navigator.pop(context);
            },
          ),

          // خيار قربت تنتهي
          FilterOptionTile(
            displayTitle:LanguageKeys.lowStockCategoryKey,
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
            onTap: () {
              onFilterSelected(LanguageKeys.lowStockCategoryKey);
              Navigator.pop(context);
            },
          ),

          // خيار منتهية
          FilterOptionTile(
            displayTitle: LanguageKeys.expiredCategoryKey,
            icon: Icons.error_outline,
            color: Colors.red,
            onTap: () {
              onFilterSelected(LanguageKeys.expiredCategoryKey);
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}