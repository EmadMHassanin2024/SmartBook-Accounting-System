import 'package:flutter/material.dart';

import '../data/models/core_module.dart';

extension CoreModuleExtension on CoreModule {

  ///----------------------------
  /// Arabic Name
  ///----------------------------

  String get arabicName {

    switch (this) {

      case CoreModule.pos:
        return "نقطة البيع";

      case CoreModule.sales:
        return "المبيعات";

      case CoreModule.purchases:
        return "المشتريات";

      case CoreModule.inventory:
        return "المخزون";

      case CoreModule.accounting:
        return "الحسابات";

      case CoreModule.crm:
        return "العملاء";

      case CoreModule.suppliers:
        return "الموردون";

      case CoreModule.finance:
        return "الخزينة";

      case CoreModule.reports:
        return "التقارير";

      case CoreModule.settings:
        return "الإعدادات";
    }
  }

  ///----------------------------
  /// English Name
  ///----------------------------

  String get englishName {

    return name.toUpperCase();

  }

  ///----------------------------
  /// Icon
  ///----------------------------

  IconData get icon {

    switch (this) {

      case CoreModule.pos:
        return Icons.point_of_sale;

      case CoreModule.sales:
        return Icons.shopping_cart;

      case CoreModule.purchases:
        return Icons.shopping_bag;

      case CoreModule.inventory:
        return Icons.inventory_2;

      case CoreModule.accounting:
        return Icons.calculate;

      case CoreModule.crm:
        return Icons.people;

      case CoreModule.suppliers:
        return Icons.local_shipping;

      case CoreModule.finance:
        return Icons.account_balance_wallet;

      case CoreModule.reports:
        return Icons.bar_chart;

      case CoreModule.settings:
        return Icons.settings;

    }

  }

  ///----------------------------
  /// Description
  ///----------------------------

  String get description {

    switch (this) {

      case CoreModule.pos:
        return "إدارة عمليات البيع.";

      case CoreModule.sales:
        return "إدارة المبيعات.";

      case CoreModule.purchases:
        return "إدارة المشتريات.";

      case CoreModule.inventory:
        return "إدارة المخزون.";

      case CoreModule.accounting:
        return "إدارة الحسابات.";

      case CoreModule.crm:
        return "إدارة العملاء.";

      case CoreModule.suppliers:
        return "إدارة الموردين.";

      case CoreModule.finance:
        return "إدارة الخزينة والبنوك.";

      case CoreModule.reports:
        return "التقارير والإحصائيات.";

      case CoreModule.settings:
        return "إعدادات النظام.";

    }

  }

}
