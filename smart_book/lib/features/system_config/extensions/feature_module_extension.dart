import 'package:flutter/material.dart';

import '../data/models/feature_module.dart';

extension FeatureModuleUIExtension on FeatureModule {

  String get arabicName {
    switch (this) {

      case FeatureModule.barcodeScanner:
        return "قارئ الباركود";

      case FeatureModule.barcodePrinting:
        return "طباعة الباركود";

      case FeatureModule.weightScale:
        return "الميزان الإلكتروني";

      case FeatureModule.batchTracking:
        return "إدارة التشغيلات";

      case FeatureModule.expiryManagement:
        return "إدارة الصلاحية";

      case FeatureModule.prescription:
        return "الوصفات الطبية";

      case FeatureModule.medicineAlternatives:
        return "بدائل الدواء";

      case FeatureModule.dosageInstructions:
        return "تعليمات الجرعات";

      case FeatureModule.controlledDrugs:
        return "الأدوية المقيدة";

      case FeatureModule.insuranceSupport:
        return "التأمين الطبي";

      case FeatureModule.tableManagement:
        return "إدارة الطاولات";

      case FeatureModule.kitchenDisplay:
        return "شاشة المطبخ";

      case FeatureModule.deliveryManagement:
        return "إدارة التوصيل";

      case FeatureModule.takeAway:
        return "تيك أواي";

      case FeatureModule.splitBill:
        return "تقسيم الفاتورة";

      case FeatureModule.multiWarehouse:
        return "متعدد المخازن";

      case FeatureModule.multiBranch:
        return "متعدد الفروع";

      case FeatureModule.multiCurrency:
        return "متعدد العملات";

      case FeatureModule.taxManagement:
        return "إدارة الضرائب";

      case FeatureModule.loyaltyPoints:
        return "نقاط الولاء";

      case FeatureModule.giftCards:
        return "بطاقات الهدايا";

      case FeatureModule.offlineMode:
        return "العمل بدون إنترنت";
    }
  }

  String get englishName => name;

  IconData get icon {
    switch (this) {

      case FeatureModule.barcodeScanner:
        return Icons.qr_code_scanner;

      case FeatureModule.barcodePrinting:
        return Icons.print;

      case FeatureModule.weightScale:
        return Icons.monitor_weight;

      case FeatureModule.batchTracking:
        return Icons.inventory_2;

      case FeatureModule.expiryManagement:
        return Icons.event;

      case FeatureModule.prescription:
        return Icons.receipt_long;

      case FeatureModule.medicineAlternatives:
        return Icons.medication;

      case FeatureModule.dosageInstructions:
        return Icons.menu_book;

      case FeatureModule.controlledDrugs:
        return Icons.health_and_safety;

      case FeatureModule.insuranceSupport:
        return Icons.health_and_safety_outlined;

      case FeatureModule.tableManagement:
        return Icons.table_restaurant;

      case FeatureModule.kitchenDisplay:
        return Icons.kitchen;

      case FeatureModule.deliveryManagement:
        return Icons.delivery_dining;

      case FeatureModule.takeAway:
        return Icons.takeout_dining;

      case FeatureModule.splitBill:
        return Icons.receipt;

      case FeatureModule.multiWarehouse:
        return Icons.warehouse;

      case FeatureModule.multiBranch:
        return Icons.account_tree;

      case FeatureModule.multiCurrency:
        return Icons.currency_exchange;

      case FeatureModule.taxManagement:
        return Icons.calculate;

      case FeatureModule.loyaltyPoints:
        return Icons.card_giftcard;

      case FeatureModule.giftCards:
        return Icons.redeem;

      case FeatureModule.offlineMode:
        return Icons.cloud_off;
    }
  }

  String get description => arabicName;
}