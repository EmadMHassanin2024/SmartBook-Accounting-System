import 'package:flutter/material.dart';
import '../../features/dashboard/screens/main_dashboard_screen.dart';
import '../../features/pos/screens/pos_screen.dart';
import '../../features/reports/screens/reports_menu_screen.dart';
import '../../features/settings/screens/settings_main_screen.dart';
import 'navigation_menu.dart'; // استيراد صفحة الإعدادات

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  // القائمة النهائية للصفحات المرتبطة بالشريط السفلي
  final List<Widget> _screens = [
    const MainDashboardScreen(),
    const POSScreen(),
    const ReportsMenuScreen(),
    const SettingsMainScreen(),   // صفحة الإعدادات الجديدة
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // استخدام IndexedStack يحافظ على حالة الصفحات عند التنقل
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_rounded), label: "الكاشير"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: "التقارير"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_suggest_rounded), label: "الإعدادات"),
        ],
      ),
    );
  }
}