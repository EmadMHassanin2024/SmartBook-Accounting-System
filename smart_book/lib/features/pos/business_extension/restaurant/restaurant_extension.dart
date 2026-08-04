import 'package:flutter/material.dart';

import '../../core/business_extension.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';

class RestaurantExtension extends BusinessExtension {
  @override
  String get extensionName => "مطعم";

  @override
  Widget buildProductDetails(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text(
          "إضافات: (بدون بصل، زيادة صوص)",
          style: TextStyle(
            fontSize: 10,
            color: Colors.orange.shade800,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  List<Widget> buildCartExtraActions(CartItemModel item) {
    return [
      // إجراءات المطعم مثل: اختيار رقم الطاولة أو حالة الطلب
      IconButton(
        icon: const Icon(Icons.table_restaurant),
        onPressed: () {
          // TODO: [System Configuration] - فتح نافذة اختيار الطاولة
        },
      ),
    ];
  }

  @override
  List<FeatureType> get supportedFeatures => [
    FeatureType.tableManagement,    // إدارة الطاولات
    FeatureType.kitchenDisplay,     // إرسال الطلب للمطبخ
    FeatureType.splitBill,          // تقسيم الفاتورة
  ];
}