
import 'package:smart_book/features/inventory/auth_exports.dart';


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
          Expanded(
            child: GestureDetector(
              onTap: onTotalTap,
              child: _buildStatCard(context.lang.allProducts, totalCount.toString(), Colors.blue),
            ),
          ),
          const SizedBox(width: 10),
          // بطاقة قربت تنتهي
          Expanded(
            child: GestureDetector(
              onTap: onLowStockTap,
              child: _buildStatCard(context.lang.lowStock, lowStockCount.toString(), Colors.orange),
            ),
          ),
          const SizedBox(width: 10),
          // بطاقة منتهية
          Expanded(
            child: GestureDetector(
              onTap: onOutOfStockTap,
              child: _buildStatCard(context.lang.outOfStock, outOfStockCount.toString(), Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // دالة بناء شكل البطاقة
  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
        ],
      ),
    );
  }
}