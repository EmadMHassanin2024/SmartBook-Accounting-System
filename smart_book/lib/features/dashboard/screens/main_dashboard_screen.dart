import 'package:smart_book/features/inventory/auth_exports.dart';
import 'package:smart_book/features/dashboard/auth_exports.dart';

import '../../../l10n/app_localizations.dart';



class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(lang.appTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: AppColors.cardBg,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. التنبيه الذكي
            BlocBuilder<InventoryCubit, InventoryState>(
              builder: (context, state) {
                if (state is InventoryLoaded &&
                    (state.lowStockItems.isNotEmpty || state.outOfStockItems.isNotEmpty)) {
                  return StockAlertWidget(state: state);
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 10),

            // 2. كرت التحليلات
            const AnalyticsPromoCard(),

            const SizedBox(height: 20),

            // 3. الإحصائيات السريعة
            Text(lang.quickSummary, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            const QuickStatsRow(),

            const SizedBox(height: 24),

            // 4. العمليات السريعة (الشبكة)
            Text(lang.quickActions, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            const QuickActionsGrid(),
          ],
        ),
      ),
    );
  }
}