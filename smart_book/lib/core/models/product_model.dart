import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../models/ ProductUnitModel.dart';


@immutable
class ProductModel extends Equatable {
  final int? productId;

  final String productNameAr;
  final String? barcode;
  final double costPrice;
  final double sellingPrice;
  final double stock; // تمثل totalStockQuantity
  final String? imagePath;
  final List<ProductUnitModel>? productUnits; // إضافة القائمة المفقودة

  const ProductModel({
    this.productId,
    required this.productNameAr,
    this.barcode,
    required this.costPrice,
    required this.sellingPrice,
    this.stock = 0.0,
    this.imagePath,
    this.productUnits,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final units = (json['productUnits'] as List?) ?? [];
    double purchasePrice = 0.0;
    double salePrice = 0.0;

    if (units.isNotEmpty) {
      purchasePrice = (units[0]['purchasePrice'] as num?)?.toDouble() ?? 0.0;
      salePrice = (units[0]['salePrice'] as num?)?.toDouble() ?? 0.0;
    }

    return ProductModel(
      productId: json['productId'] as int?,
      productNameAr: json['productNameAr']?.toString() ?? 'صنف بدون اسم',
      barcode: json['barcode']?.toString(),
      costPrice: (json['costPrice'] as num?)?.toDouble() ?? purchasePrice,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? salePrice,
      stock: (json['totalStockQuantity'] as num?)?.toDouble() ?? 0.0,
      imagePath: json['imagePath']?.toString(),
      productUnits: units.map((u) => ProductUnitModel.fromJson(u)).toList(),
    );
  }


  ProductModel copyWith({
    int? productId,
    String? productNameAr,
    String? barcode,
    double? costPrice,
    double? sellingPrice,
    double? stock,
    String? imagePath,
    List<ProductUnitModel>? productUnits,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      productNameAr: productNameAr ?? this.productNameAr,
      barcode: barcode ?? this.barcode,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stock: stock ?? this.stock,
      imagePath: imagePath ?? this.imagePath,
      productUnits: productUnits ?? this.productUnits,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "ProductNameAr": productNameAr,
      "Barcode": barcode,
      "TotalStockQuantity": stock,
      "CostPrice": costPrice,
      "SellingPrice": sellingPrice,
      "ProductUnits": productUnits?.map((unit) => unit.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    productId,
    productNameAr,
    barcode,
    costPrice,
    sellingPrice,
    stock,
    imagePath,
    productUnits
  ];
}