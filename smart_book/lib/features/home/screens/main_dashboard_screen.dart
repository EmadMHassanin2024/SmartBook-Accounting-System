import 'package:flutter/material.dart';

// استيراد الصفحات
import '../../../core/theme/app_colors.dart';


import '../../finance/accounting/models/voucher_model.dart';
import '../../finance/accounting/screens/chart_of_accounts_screen.dart';
import '../../finance/accounting/screens/payment_voucher_screen.dart';
import '../../inventory/screens/items_list_screen.dart';
import '../../invoices/screens/invoices_list_screen.dart';
import '../../contacts/screens/contacts_list_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة الكروت
    final menuItems = [
      _MenuItem(
        title: "الفواتير",
        icon: Icons.receipt_long,
        color: AppColors.primaryBlue,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const InvoicesListScreen())),
      ),
      _MenuItem(
        title: "المخزون",
        icon: Icons.inventory_2,
        color: Colors.orange,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ItemsListScreen())),
      ),
      _MenuItem(
        title: "العملاء",
        icon: Icons.people_alt,
        color: Colors.teal,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ContactsListScreen())),
      ),
      _MenuItem(
        title: "الدليل",
        icon: Icons.account_tree,
        color: Colors.purple,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ChartOfAccountsScreen())),
      ),
      _MenuItem(
        title: "سند قبض",
        icon: Icons.add_card,
        color: AppColors.successGreen,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const VoucherScreen(type: VoucherType.receipt))),
      ),
      _MenuItem(
        title: "سند صرف",
        icon: Icons.payments,
        color: AppColors.errorRed,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const VoucherScreen(type: VoucherType.payment))),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          "لوحة التحكم",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.cardBg,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200, // أقصى عرض للكارت
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 65, // ارتفاع ثابت
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
          },
        ),
      ),
    );
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dividerColor.withOpacity(0.6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
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

// نموذج بيانات الكارت
class _MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _MenuItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
