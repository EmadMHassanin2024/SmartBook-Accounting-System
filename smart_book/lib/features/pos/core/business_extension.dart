import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';

// 1. تعريف التعداد (Enum) لأنواع الأنشطة
enum BusinessModuleType {
  general,
  pharmacy,
  restaurant
}

// TODO: [System Configuration] - واجهة التعريف للأنشطة المختلفة
abstract class BusinessExtension {
  // معرف النشاط البرمجي
  BusinessModuleType get moduleType;

  // اسم النشاط (مثل: "صيدلية"، "مطعم"، "عام")
  String get extensionName;

  // واجهة لعرض تفاصيل إضافية للمنتج (مثل الـ Batch في الصيدلية أو الإضافات في المطعم)
  Widget buildProductDetails(ProductModel product);

  // واجهة لعرض إجراءات إضافية داخل السلة (مثل تعديل رقم الطاولة)
  List<Widget> buildCartExtraActions(CartItemModel item);

  /// جميع المزايا التي يدعمها هذا النشاط
  List<FeatureType> get supportedFeatures;

  /// للتحقق بسهولة
  bool supports(FeatureType feature) {
    return supportedFeatures.contains(feature);
  }
}

// feature_type.dart
enum FeatureType {
  // البيع
  barcodeScanner,
  barcodePrinting,
  weightScale,

  // الصيدليات
  batchTracking,
  expiryManagement,
  prescription,
  medicineAlternatives,
  dosageInstructions,
  controlledDrugs,
  insuranceSupport,

  // المطاعم
  tableManagement,
  kitchenDisplay,
  deliveryManagement,
  takeAway,
  splitBill,

  // الإدارة
  multiWarehouse,
  multiBranch,
  multiCurrency,
  taxManagement,

  // التسويق
  loyaltyPoints,
  giftCards,

  // النظام
  offlineMode,
}