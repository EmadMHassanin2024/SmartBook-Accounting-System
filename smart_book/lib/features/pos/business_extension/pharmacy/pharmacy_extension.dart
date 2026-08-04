import 'package:flutter/material.dart';

import '../../core/business_extension.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';

import 'pharmacy_cart_actions.dart';
import 'pharmacy_product_details.dart';

class PharmacyExtension extends BusinessExtension {
  @override
  String get extensionName => "صيدلية";

  /// تفاصيل إضافية تظهر داخل كارت المنتج
  @override
  Widget buildProductDetails(ProductModel product) {
    return PharmacyProductDetails(product: product);
  }

  /// أزرار إضافية داخل السلة
  @override
  List<Widget> buildCartExtraActions(CartItemModel item) {
    return buildPharmacyCartActions(item);
  }

  /// المزايا التي يدعمها نشاط الصيدلية
  @override
  List<FeatureType> get supportedFeatures => [
    FeatureType.barcodeScanner,
    FeatureType.barcodePrinting,
    FeatureType.batchTracking,
    FeatureType.expiryManagement,
    FeatureType.prescription,
    FeatureType.medicineAlternatives,
    FeatureType.dosageInstructions,
    FeatureType.controlledDrugs,
    FeatureType.insuranceSupport,
    FeatureType.multiWarehouse,
  ];
}