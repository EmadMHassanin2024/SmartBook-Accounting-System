import 'package:flutter/material.dart';
import 'package:smart_book/core/theme/app_colors.dart';
import 'package:smart_book/features/dashboard/screens/main_dashboard_screen.dart';
import 'package:smart_book/l10n/app_localizations.dart';

// استيراد الشاشات
import '../../features/auth/widgets/auth_app_bar.dart';
import '../../features/contacts/screens/contacts_list_screen.dart';
import '../../features/finance/accounting/models/voucher_model.dart';
import '../../features/finance/accounting/screens/chart_of_accounts_screen.dart';
import '../../features/finance/accounting/screens/payment_voucher_screen.dart';
import '../../features/finance/journals/Screans/JournalListScreen.dart';
import '../../features/inventory/screens/items_list_screen.dart';
import '../../features/invoices/screens/invoices_list_screen.dart';
import '../../features/pos/screens/pos_screen.dart';
import '../../features/finance/Account/screens/AccountsListScreen.dart';
import '../../features/finance/TrialBalance/Screans/TrialBalanceScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // البدء باللوحة الرئيسية (الاندكس 2)

  final List<Widget> _pages = [
    const POSScreen(),             // 0
    const ItemsListScreen(),       // 1
    const MainDashboardScreen(),   // 2
    const InvoicesListScreen(),    // 3
    const ChartOfAccountsScreen(), // 4
  ];

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,

      // 1. استخدام الهيدر الموحد الجاهز
      appBar: const AuthAppBar(primaryColor: AppColors.primaryBlue),

      // 2. المحتوى المتغير
      body: _pages[_currentIndex],

      // 3. القائمة الجانبية الثابتة
      drawer: _buildGlobalDrawer(context, lang),

      // 4. الشريط السفلي للتنقل السريع
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: "النقاط"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: "المخزون"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "الفواتير"),
          BottomNavigationBarItem(icon: Icon(Icons.account_tree), label: "الدليل"),
        ],
      ),
    );
  }

  // القائمة الجانبية
  Widget _buildGlobalDrawer(BuildContext context, AppLocalizations lang) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryBlue),
            child: Center(
                child: Text(
                    lang.appName,
                    style: const TextStyle(color: Colors.white, fontSize: 20)
                )
            ),
          ),
          _buildDrawerItem(context, "قيود اليومية", Icons.menu_book, const JournalListScreen()),
          _buildDrawerItem(context, "دفتر الأستاذ", Icons.view_list, const AccountsListScreen()),
          _buildDrawerItem(context, "سند قبض", Icons.add_card, const VoucherScreen(type: VoucherType.receipt)),
          _buildDrawerItem(context, "سند صرف", Icons.payments, const VoucherScreen(type: VoucherType.payment)),
          _buildDrawerItem(context, "ميزان المراجعة", Icons.account_balance, const TrialBalanceScreen()),
          _buildDrawerItem(context, "العملاء", Icons.people_alt, const ContactsListScreen()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, Widget page) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // إغلاق الـ Drawer
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}