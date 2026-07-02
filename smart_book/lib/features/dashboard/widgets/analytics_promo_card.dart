import 'package:smart_book/features/inventory/auth_exports.dart';
import 'package:smart_book/features/sales/Screans/sales_analytics_screen.dart';
import '../../../l10n/app_localizations.dart';
//مسؤول عن عرض كرت التحليلات الذكية
class AnalyticsPromoCard extends StatelessWidget {
  const AnalyticsPromoCard( {super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalesAnalyticsScreen())),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primaryBlue, Color(0xFF1E88E5)]),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.insights, color: Colors.white, size: 35),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lang.smartAnalytics, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(lang.viewCharts, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}