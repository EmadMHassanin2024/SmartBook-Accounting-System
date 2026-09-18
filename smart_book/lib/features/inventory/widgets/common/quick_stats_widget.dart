import 'package:smart_book/features/inventory/auth_exports.dart';
import '../../../../core/localization/language_keys.dart';
import 'StatCardItem.dart';

class QuickStatsWidget extends StatelessWidget {
  final VoidCallback? onTotalTap;
  final VoidCallback? onLowStockTap;
  final VoidCallback? onOutOfStockTap;
  final int totalCount;
  final int lowStockCount;
  final int outOfStockCount;

  const QuickStatsWidget({
    super.key,
    this.onTotalTap,
    this.onLowStockTap,
    this.onOutOfStockTap,
    required this.totalCount,
    required this.lowStockCount,
    required this.outOfStockCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // بطاقة كل الأصناف
          StatCardItem(
            title: LanguageKeys.allCategoryKey,
            count: totalCount.toString(),
            color: Colors.blue,
            onTap: onTotalTap,
          ),
          const SizedBox(width: 10),

          // بطاقة قربت تنتهي
          StatCardItem(
            title: LanguageKeys.lowStockCategoryKey,
            count: lowStockCount.toString(),
            color: Colors.orange,
            onTap: onLowStockTap,
          ),
          const SizedBox(width: 10),

          // بطاقة منتهية
          StatCardItem(
            title: LanguageKeys.expiredCategoryKey,
            count: outOfStockCount.toString(),
            color: Colors.red,
            onTap: onOutOfStockTap,
          ),
        ],
      ),
    );
  }
}