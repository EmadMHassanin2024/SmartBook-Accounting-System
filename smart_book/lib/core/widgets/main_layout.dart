import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/core/theme/app_colors.dart';
import 'package:smart_book/features/dashboard/screens/main_dashboard_screen.dart';

import 'package:smart_book/l10n/app_localizations.dart';



import 'package:smart_book/features/auth/widgets/auth_app_bar.dart';

import 'package:smart_book/features/contacts/screens/contacts_list_screen.dart';



import 'package:smart_book/features/finance/accounting/models/voucher_model.dart';

import 'package:smart_book/features/finance/accounting/screens/chart_of_accounts_screen.dart';

import 'package:smart_book/features/finance/accounting/screens/payment_voucher_screen.dart';



import 'package:smart_book/features/finance/journals/Screans/JournalListScreen.dart';

import 'package:smart_book/features/finance/Account/screens/AccountsListScreen.dart';

import 'package:smart_book/features/finance/TrialBalance/Screans/TrialBalanceScreen.dart';



import 'package:smart_book/features/inventory/screens/items_list_screen.dart';

import 'package:smart_book/features/invoices/screens/invoices_list_screen.dart';

import 'package:smart_book/features/pos/presentation/screens/pos_screen.dart';



import 'package:smart_book/features/system_config/data/models/core_module.dart';

import 'package:smart_book/features/system_config/data/models/system_settings_model.dart';

import 'package:smart_book/features/system_config/logic/system_configuration_cubit.dart';

import 'package:smart_book/features/system_config/logic/system_configuration_state.dart';



import 'package:smart_book/features/system_config/presentation/screens/system_config_screen.dart';





class _NavigationItem {

  final String title;

  final IconData icon;

  final Widget page;

  final CoreModule? requiredModule;



  const _NavigationItem({

    required this.title,

    required this.icon,

    required this.page,

    this.requiredModule,

  });

}



// ===============================================================

// Main Screen

// ===============================================================



class MainScreen extends StatefulWidget {

  const MainScreen({super.key});



  @override

  State<MainScreen> createState() => _MainScreenState();

}



class _MainScreenState extends State<MainScreen> {



  int _currentIndex = 0;



  @override

  Widget build(BuildContext context) {

    final lang = AppLocalizations.of(context)!;



    return BlocBuilder<SystemConfigurationCubit,

        SystemConfigurationState>(

      builder: (context, state) {



        final SystemSettingsModel settings = state.settings;







        final List<_NavigationItem> navigationItems =

        _buildNavigationItems(settings);







        if (navigationItems.isNotEmpty &&

            _currentIndex >= navigationItems.length) {

          _currentIndex = 0;

        }



        return Scaffold(

          backgroundColor: AppColors.scaffoldBg,



          appBar: const AuthAppBar(

            primaryColor: AppColors.primaryBlue,

          ),



// الصفحة الحالية



          body: navigationItems.isEmpty

              ? _buildEmptyConfigurationScreen()

              : navigationItems[_currentIndex].page,



// ========================================================

// Drawer

// ========================================================



          drawer: _buildGlobalDrawer(

            context,

            lang,

            settings,

          ),





// Bottom Navigation





          bottomNavigationBar: navigationItems.isEmpty

              ? null

              : BottomNavigationBar(

            type: BottomNavigationBarType.fixed,

            selectedItemColor: AppColors.primaryBlue,

            currentIndex: _currentIndex,

            onTap: (index) {

              setState(() {

                _currentIndex = index;

              });

            },

            items: navigationItems

                .map(

                  (item) => BottomNavigationBarItem(

                icon: Icon(item.icon),

                label: item.title,

              ),

            )

                .toList(),

          ),

        );

      },

    );

  }





  List<_NavigationItem> _buildNavigationItems(

      SystemSettingsModel settings,

      ) {

    final List<_NavigationItem> items = [];







    items.add(

      const _NavigationItem(

        title: 'الرئيسية',

        icon: Icons.dashboard_customize,

        page: MainDashboardScreen(),

      ),

    );





    items.add(

      const _NavigationItem(

        title: 'إعدادات النظام',

        icon: Icons.settings,

        page: SystemConfigurationScreen(),

      ),

    );

// POS





    if (settings.hasCoreModule(CoreModule.pos)) {

      items.add(

        const _NavigationItem(

          title: 'نقطة البيع',

          icon: Icons.point_of_sale,

          page: POSScreen(),

          requiredModule: CoreModule.pos,

        ),

      );

    }



// =============================================================

// Inventory

// =============================================================



    if (settings.hasCoreModule(CoreModule.inventory)) {

      items.add(

        const _NavigationItem(

          title: 'المخزون',

          icon: Icons.inventory_2,

          page: ItemsListScreen(),

          requiredModule: CoreModule.inventory,

        ),

      );

    }





    if (settings.hasCoreModule(CoreModule.sales)) {

      items.add(

        const _NavigationItem(

          title: 'المبيعات',

          icon: Icons.receipt_long,

          page: InvoicesListScreen(),

          requiredModule: CoreModule.sales,

        ),

      );

    }



// =============================================================

// Accounting

// =============================================================



    if (settings.hasCoreModule(CoreModule.accounting)) {

      items.add(

        const _NavigationItem(

          title: 'الحسابات',

          icon: Icons.account_tree,

          page: ChartOfAccountsScreen(),

          requiredModule: CoreModule.accounting,

        ),

      );

    }



    return items;

  }



// ===============================================================

// Global Drawer

// ===============================================================



  Widget _buildGlobalDrawer(

      BuildContext context,

      AppLocalizations lang,

      SystemSettingsModel settings,

      ) {

    return Drawer(

      child: ListView(

        padding: EdgeInsets.zero,

        children: [

// ========================================================

// Header

// ========================================================



          DrawerHeader(

            decoration: const BoxDecoration(

              color: AppColors.primaryBlue,

            ),

            child: Center(

              child: Text(

                settings.companyName.isNotEmpty

                    ? settings.companyName

                    : lang.appName,

                style: const TextStyle(

                  color: Colors.white,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                ),

              ),

            ),

          ),



// ========================================================

// POS

// ========================================================



          if (settings.hasCoreModule(CoreModule.pos))

            _buildDrawerItem(

              context,

              'نقطة البيع',

              Icons.point_of_sale,

              const POSScreen(),

            ),



// ========================================================

// Inventory

// ========================================================



          if (settings.hasCoreModule(CoreModule.inventory))

            _buildDrawerItem(

              context,

              'إدارة المخزون',

              Icons.inventory_2,

              const ItemsListScreen(),

            ),





// ========================================================

// Sales

// ========================================================



          if (settings.hasCoreModule(CoreModule.sales))

            _buildDrawerItem(

              context,

              'المبيعات',

              Icons.receipt_long,

              const InvoicesListScreen(),

            ),



// ========================================================

// Accounting

// ========================================================



          if (settings.hasCoreModule(CoreModule.accounting)) ...[

            _buildDrawerItem(

              context,

              'الدليل المحاسبي',

              Icons.account_tree,

              const ChartOfAccountsScreen(),

            ),



            _buildDrawerItem(

              context,

              'قيود اليومية',

              Icons.menu_book,

              const JournalListScreen(),

            ),



            _buildDrawerItem(

              context,

              'دفتر الأستاذ',

              Icons.view_list,

              const AccountsListScreen(),

            ),



            _buildDrawerItem(

              context,

              'ميزان المراجعة',

              Icons.account_balance,

              const TrialBalanceScreen(),

            ),



            _buildDrawerItem(

              context,

              'سند قبض',

              Icons.add_card,

              const VoucherScreen(

                type: VoucherType.receipt,

              ),

            ),



            _buildDrawerItem(

              context,

              'سند صرف',

              Icons.payments,

              const VoucherScreen(

                type: VoucherType.payment,

              ),

            ),

          ],



// ========================================================

// CRM

// ========================================================



          if (settings.hasCoreModule(CoreModule.crm))

            _buildDrawerItem(

              context,

              'العملاء',

              Icons.people_alt,

              const ContactsListScreen(),

            ),



// ========================================================

// Divider

// ========================================================











        ],

      ),

    );

  }



// ===============================================================

// Drawer Item

// ===============================================================



  Widget _buildDrawerItem(

      BuildContext context,

      String title,

      IconData icon,

      Widget page,

      ) {

    return ListTile(

      leading: Icon(

        icon,

        color: AppColors.primaryBlue,

      ),

      title: Text(title),

      onTap: () {

// إغلاق Drawer

        Navigator.pop(context);



// فتح الصفحة

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) => page,

          ),

        );

      },

    );

  }



// ===============================================================

// Empty Configuration Screen

// ===============================================================



  Widget _buildEmptyConfigurationScreen() {

    return const Center(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(

            Icons.settings_suggest,

            size: 60,

            color: Colors.grey,

          ),

          SizedBox(height: 16),

          Text(

            'لم يتم تفعيل أي موديول',

            style: TextStyle(

              fontSize: 18,

              fontWeight: FontWeight.bold,

            ),

          ),

          SizedBox(height: 8),

          Text(

            'يرجى الدخول إلى إعدادات النظام وتفعيل الموديولات.',

            textAlign: TextAlign.center,

          ),

        ],

      ),

    );

  }

}

