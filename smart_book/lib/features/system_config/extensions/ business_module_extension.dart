
import 'package:flutter/material.dart';

import '../data/models/ business_module.dart';



extension BusinessModuleUIExtension on BusinessModule {

  String get arabicName {
    switch (this) {
      case BusinessModule.pharmacy:
        return "الصيدلية";

      case BusinessModule.restaurant:
        return "المطعم";

      case BusinessModule.cafe:
        return "الكافيه";

      case BusinessModule.supermarket:
        return "السوبر ماركت";

      case BusinessModule.generalStore:
        return "المتجر العام";

      case BusinessModule.fashion:
        return "الملابس والأحذية";

      case BusinessModule.autoParts:
        return "قطع الغيار";

      case BusinessModule.electronics:
        return "الإلكترونيات";

      case BusinessModule.bookstore:
        return "المكتبة";

      case BusinessModule.bakery:
        return "المخبز";

      case BusinessModule.jewelry:
        return "المجوهرات";

      case BusinessModule.medicalSupplies:
        return "المستلزمات الطبية";
    }
  }

  String get englishName {
    switch (this) {
      case BusinessModule.pharmacy:
        return "Pharmacy";

      case BusinessModule.restaurant:
        return "Restaurant";

      case BusinessModule.cafe:
        return "Cafe";

      case BusinessModule.supermarket:
        return "Supermarket";

      case BusinessModule.generalStore:
        return "General Store";

      case BusinessModule.fashion:
        return "Fashion";

      case BusinessModule.autoParts:
        return "Auto Parts";

      case BusinessModule.electronics:
        return "Electronics";

      case BusinessModule.bookstore:
        return "Bookstore";

      case BusinessModule.bakery:
        return "Bakery";

      case BusinessModule.jewelry:
        return "Jewelry";

      case BusinessModule.medicalSupplies:
        return "Medical Supplies";
    }
  }

  IconData get icon {
    switch (this) {
      case BusinessModule.pharmacy:
        return Icons.local_pharmacy;

      case BusinessModule.restaurant:
        return Icons.restaurant;

      case BusinessModule.cafe:
        return Icons.local_cafe;

      case BusinessModule.supermarket:
        return Icons.shopping_cart;

      case BusinessModule.generalStore:
        return Icons.store;

      case BusinessModule.fashion:
        return Icons.checkroom;

      case BusinessModule.autoParts:
        return Icons.directions_car;

      case BusinessModule.electronics:
        return Icons.devices;

      case BusinessModule.bookstore:
        return Icons.menu_book;

      case BusinessModule.bakery:
        return Icons.bakery_dining;

      case BusinessModule.jewelry:
        return Icons.diamond;

      case BusinessModule.medicalSupplies:
        return Icons.medical_services;
    }
  }

  String get description {
    switch (this) {
      case BusinessModule.pharmacy:
        return "إدارة الصيدليات.";

      case BusinessModule.restaurant:
        return "إدارة المطاعم.";

      case BusinessModule.cafe:
        return "إدارة الكافيهات.";

      case BusinessModule.supermarket:
        return "إدارة السوبر ماركت.";

      case BusinessModule.generalStore:
        return "إدارة المتاجر.";

      case BusinessModule.fashion:
        return "إدارة الملابس.";

      case BusinessModule.autoParts:
        return "إدارة قطع الغيار.";

      case BusinessModule.electronics:
        return "إدارة الإلكترونيات.";

      case BusinessModule.bookstore:
        return "إدارة المكتبات.";

      case BusinessModule.bakery:
        return "إدارة المخابز.";

      case BusinessModule.jewelry:
        return "إدارة المجوهرات.";

      case BusinessModule.medicalSupplies:
        return "إدارة المستلزمات الطبية.";
    }
  }
}