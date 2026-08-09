import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

import '../../contacts/screens/contacts_list_screen.dart';

import '../../finance/accounting/models/voucher_model.dart';
import '../../finance/accounting/screens/chart_of_accounts_screen.dart';
import '../../finance/accounting/screens/payment_voucher_screen.dart';

// الاستيرادات الخاصة بالشاشات المحاسبية المضافة للاختصارات
import '../../finance/journals/Screans/JournalListScreen.dart';
import '../../finance/Account/screens/AccountsListScreen.dart';
import '../../finance/TrialBalance/Screans/TrialBalanceScreen.dart';

import '../../inventory/auth_exports.dart';
import '../../inventory/screens/items_list_screen.dart';

import '../../invoices/screens/invoices_list_screen.dart';

import '../widgets/analytics_promo_card.dart';
import '../widgets/quick_stats_row.dart';
import '../widgets/stock_alert_widget.dart';


///
/// Dashboard الرئيسي للنظام
///
/// مسؤول عن:
/// 1. عرض تنبيهات المخزون
/// 2. عرض التحليلات
/// 3. عرض الإحصائيات السريعة
/// 4. عرض الاختصارات السريعة
///
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() =>
      _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {

  @override
  void initState() {
    super.initState();

    // جلب المنتجات عند فتح Dashboard
    context.read<InventoryCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ============================================================
          // 1️⃣ تنبيهات المخزون
          // ============================================================

          BlocBuilder<InventoryCubit, InventoryState>(
            builder: (context, state) {

              if (state is InventoryLoaded &&
                  (
                      state.lowStockItems.isNotEmpty ||
                          state.outOfStockItems.isNotEmpty
                  )) {
                return StockAlertWidget(
                  state: state,
                );
              }

              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 10),

          // ============================================================
          // 2️⃣ كرت التحليلات
          // ============================================================

          const AnalyticsPromoCard(),

          const SizedBox(height: 24),

          // ============================================================
          // 3️⃣ الإحصائيات السريعة
          // ============================================================

          Text(
            lang.quickSummary,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 10),

          const QuickStatsRow(),

          const SizedBox(height: 28),

          // ============================================================
          // 4️⃣ الاختصارات السريعة
          // ============================================================

          Text(
            lang.quickActions,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 10),

          _buildQuickActions(context),
        ],
      ),
    );
  }

  // ==================================================================
  // الاختصارات السريعة
  // ==================================================================
  Widget _buildQuickActions(BuildContext context) {
    final menuItems = <_MenuItem>[

      // --------------------------------------------------------------
      // الفواتير
      // --------------------------------------------------------------
      _MenuItem(
        title: "الفواتير",
        icon: Icons.receipt_long,
        color: AppColors.primaryBlue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const InvoicesListScreen(),
            ),
          );
        },
      ),

      // --------------------------------------------------------------
      // المخزون
      // --------------------------------------------------------------
      _MenuItem(
        title: "المخزون",
        icon: Icons.inventory_2,
        color: Colors.orange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ItemsListScreen(),
            ),
          );
        },
      ),

      // --------------------------------------------------------------
      // العملاء
      // --------------------------------------------------------------
      _MenuItem(
        title: "العملاء",
        icon: Icons.people_alt,
        color: Colors.teal,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ContactsListScreen(),
            ),
          );
        },
      ),

      // --------------------------------------------------------------
      // دليل الحسابات
      // --------------------------------------------------------------
      _MenuItem(
        title: "الدليل المحاسبي",
        icon: Icons.account_tree,
        color: Colors.purple,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ChartOfAccountsScreen(),
            ),
          );
        },
      ),

      // --------------------------------------------------------------
      // قيود اليومية
      // --------------------------------------------------------------
      _MenuItem(
        title: "قيود اليومية",
        icon: Icons.menu_book,
        color: Colors.indigo,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const JournalListScreen(),
            ),
          );
        },
      ),

      // --------------------------------------------------------------
      // دفتر الأستاذ
      // --------------------------------------------------------------
      _MenuItem(
        title: "دفتر الأستاذ",
        icon: Icons.view_list,
        color: Colors.brown,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AccountsListScreen(),
            ),
          );
        },
      ),

      // --------------------------------------------------------------
      // ميزان المراجعة
      // --------------------------------------------------------------
      _MenuItem(
        title: "ميزان المراجعة",
        icon: Icons.account_balance,
        color: Colors.blueGrey,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TrialBalanceScreen(),
            ),
          );
        },
      ),

      // --------------------------------------------------------------
      // سند قبض
      // --------------------------------------------------------------
      _MenuItem(
        title: "سند قبض",
        icon: Icons.add_card,
        color: AppColors.successGreen,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VoucherScreen(
                type: VoucherType.receipt,
              ),
            ),
          );
        },
      ),

      // --------------------------------------------------------------
      // سند صرف
      // --------------------------------------------------------------
      _MenuItem(
        title: "سند صرف",
        icon: Icons.payments,
        color: AppColors.errorRed,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VoucherScreen(
                type: VoucherType.payment,
              ),
            ),
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      // مهم جدًا: لأن الصفحة نفسها SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 65,
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildCompactMenuCard(
          context,
          title: item.title,
          icon: item.icon,
          color: item.color,
          onTap: item.onTap,
        );
      },
    );
  }

  // ==================================================================
  // كارت الاختصار
  // ==================================================================

  Widget _buildCompactMenuCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.dividerColor.withOpacity(0.6),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ======================================================================
// نموذج بيانات الاختصار
// ======================================================================

class _MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}