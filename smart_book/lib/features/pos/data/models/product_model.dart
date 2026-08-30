import 'package:equatable/equatable.dart';

import '../../../../models/ ProductUnitModel.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final String barcode;
  final double price;
  final double stock;
  final double purchasePrice;
  final String imagePath;

  // ⭐ MODIFIED: نوع النشاط
  final String itemType;

  // ⭐ MODIFIED: تاريخ الصلاحية
  final String? expiryDate;

  final List<dynamic>? ingredients;

  // ⭐ MODIFIED: الاحتفاظ بكل وحدات المنتج القادمة من API
  final List<ProductUnitModel> units;

  const ProductModel({
    required this.id,
    required this.name,
    required this.barcode,
    required this.price,
    required this.stock,
    required this.purchasePrice,
    required this.imagePath,
    this.itemType = 'general',
    this.expiryDate,
    this.ingredients,

    // ⭐ MODIFIED
    this.units = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double salePrice = 0.0;
    double purchasePrice = 0.0;

    // ⭐ MODIFIED:
    // قراءة جميع وحدات المنتج بدل الاكتفاء بالوحدة الأولى
    final List<ProductUnitModel> units =
        (json['productUnits'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map((unit) => ProductUnitModel.fromJson(unit))
            .toList() ??
            [];

    // ⭐ MODIFIED:
    // تحديد الوحدة الأساسية من isBaseUnit
    ProductUnitModel? baseUnit;

    for (final unit in units) {
      if (unit.isBaseUnit) {
        baseUnit = unit;
        break;
      }
    }

    // fallback في حالة عدم وجود وحدة أساسية
    baseUnit = baseUnit ?? (units.isNotEmpty ? units.first : null);

    if (baseUnit != null) {
      salePrice = baseUnit.salePrice;
      purchasePrice = baseUnit.purchasePrice;
    }

    return ProductModel(
      id: json['productId'] ?? 0,
      name: json['productNameAr'] ?? 'صنف بدون اسم',
      barcode: json['barcode'] ?? '',
      price: salePrice,
      purchasePrice: purchasePrice,

      stock: (json['totalStockQuantity'] as num?)?.toDouble() ?? 0.0,

      imagePath: json['imagePath'] ?? '',

      itemType: json['itemType'] ?? 'general',

      expiryDate: json['expiryDate'],

      ingredients: json['ingredients'],

      // ⭐ MODIFIED
      units: units,
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? barcode,
    double? price,
    double? stock,
    double? purchasePrice,
    String? imagePath,
    String? itemType,
    String? expiryDate,
    List<dynamic>? ingredients,

    // ⭐ MODIFIED
    List<ProductUnitModel>? units,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      imagePath: imagePath ?? this.imagePath,
      itemType: itemType ?? this.itemType,
      expiryDate: expiryDate ?? this.expiryDate,
      ingredients: ingredients ?? this.ingredients,

      // ⭐ MODIFIED
      units: units ?? this.units,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    barcode,
    price,
    stock,
    purchasePrice,
    imagePath,
    itemType,
    expiryDate,
    ingredients,

    // ⭐ MODIFIED
    units,
  ];
}
