import 'package:smart_book/features/inventory/auth_exports.dart';


import '../../../l10n/app_localizations.dart';
//ملف التنبيه
class StockAlertWidget extends StatelessWidget {
  final InventoryLoaded state;
  const StockAlertWidget(  {super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    int lowCount = state.lowStockItems.length;
    int outCount = state.outOfStockItems.length;
    bool isUrgent = outCount > 0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: InkWell(
        key: ValueKey("$lowCount-$outCount"),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ItemsListScreen())),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUrgent ? Colors.red.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isUrgent ? Colors.red.shade200 : Colors.orange.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: isUrgent ? Colors.red : Colors.orange),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  outCount > 0 ? "تنبيه: $outCount منتهية و $lowCount قاربت على النفاد" : "تنبيه: $lowCount صنف قاربت على النفاد",
                  style: TextStyle(fontWeight: FontWeight.bold, color: isUrgent ? Colors.red.shade800 : Colors.orange.shade800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}