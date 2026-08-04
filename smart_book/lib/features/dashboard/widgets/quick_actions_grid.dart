import 'package:smart_book/features/inventory/auth_exports.dart';


//TODO
import '../../../l10n/app_localizations.dart';
import '../../finance/Account/screens/AccountsListScreen.dart';
import '../../finance/TrialBalance/Screans/TrialBalanceScreen.dart';
import '../../contacts/screens/contacts_list_screen.dart';
import '../../finance/accounting/models/voucher_model.dart';
import '../../finance/accounting/screens/chart_of_accounts_screen.dart';
import '../../finance/accounting/screens/payment_voucher_screen.dart';
import '../../finance/adjustments/screens/add_adjustment_screen.dart';
import '../../finance/income_statement/screens/income_statement_screen.dart';
import '../../finance/journals/Screans/JournalListScreen.dart';

import '../../invoices/screens/invoices_list_screen.dart';
import '../../pos/presentation/screens/pos_screen.dart';
import '../../system_config/presentation/screens/system_config_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid( {super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final menuItems = [
      _MenuItem(lang.pos, Icons.point_of_sale, Colors.indigo, const POSScreen()),
      _MenuItem(lang.journals, Icons.menu_book, AppColors.primaryBlue, const JournalListScreen()),
      _MenuItem(lang.ledger, Icons.view_list, AppColors.primaryBlue, const AccountsListScreen()),
      _MenuItem(lang.receiptVoucher, Icons.add_card, AppColors.successGreen, const VoucherScreen(type: VoucherType.receipt)),
      _MenuItem(lang.paymentVoucher, Icons.payments, AppColors.errorRed, const VoucherScreen(type: VoucherType.payment)),
      _MenuItem(lang.trialBalance, Icons.account_balance, Colors.blueGrey, const TrialBalanceScreen()),
      _MenuItem(lang.incomeStatement, Icons.analytics, Colors.deepPurple, const IncomeStatementScreen()),
      _MenuItem(lang.chartOfAccounts, Icons.account_tree, Colors.purple, const ChartOfAccountsScreen()),
      _MenuItem(lang.invoices, Icons.receipt_long, Colors.brown, const InvoicesListScreen()),
      _MenuItem(lang.inventory, Icons.inventory_2, Colors.orange, const ItemsListScreen()),
      _MenuItem(lang.contacts, Icons.people_alt, Colors.teal, const ContactsListScreen()),
      _MenuItem(
        lang.adjustments, // المفتاح الذي أضفناه في ملف اللغة
        Icons.edit_note,  // أيقونة مناسبة للتسويات
        Colors.deepOrangeAccent, // لون مميز للتمييز عن باقي العمليات
        const AdjustmentListScreen(), // الشاشة التي قمنا بتطويرها
      ),
      // 🌟 إضافة شاشة إعدادات النظام هنا
      _MenuItem(

        "إعدادات النظام",            // 1. الترتيب الأول: String (اسم العنصر)
        Icons.settings_applications, // 2. الترتيب الثاني: IconData
        Colors.blueGrey.shade800,    // 3. الترتيب الثالث: Color
        const SystemConfigurationScreen(), // 4. الترتيب الرابع: Widget (الشاشة)
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 65,
      ),
      itemBuilder: (context, index) => _buildCompactMenuCard(context, menuItems[index]),
    );
  }

  Widget _buildCompactMenuCard(BuildContext context, _MenuItem item) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.screen)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(item.icon, color: item.color, size: 22),
            const SizedBox(width: 8),
            Flexible(child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget screen;
  _MenuItem(this.title, this.icon, this.color, this.screen);
}