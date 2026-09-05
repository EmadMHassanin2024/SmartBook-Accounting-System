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

  // نوع النشاط
  final String itemType;

  // تاريخ الصلاحية
  final String? expiryDate;

  // 🌟 الخصائص المضافة حديثاً لتتوافق مع شاشة الإضافة والتعديل
  final String? batchNumber;
  final String? size;
  final String? color;
  final bool isIngredient;

  final List<dynamic>? ingredients;

  // الاحتفاظ بكل وحدات المنتج القادمة من API
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
    this.batchNumber,
    this.size,
    this.color,
    this.isIngredient = false,
    this.ingredients,
    this.units = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double salePrice = 0.0;
    double purchasePrice = 0.0;

    // قراءة جميع وحدات المنتج بدل الاكتفاء بالوحدة الأولى
    final List<ProductUnitModel> units =
        (json['productUnits'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map((unit) => ProductUnitModel.fromJson(unit))
            .toList() ??
            [];

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
      id: json['productId'] ?? json['id'] ?? 0,
      name: json['productNameAr'] ?? json['name'] ?? 'صنف بدون اسم',
      barcode: json['barcode'] ?? '',
      price: salePrice,
      purchasePrice: purchasePrice,
      stock: (json['totalStockQuantity'] ?? json['stock'] as num?)?.toDouble() ?? 0.0,
      imagePath: json['imagePath'] ?? '',
      itemType: json['itemType'] ?? 'general',
      expiryDate: json['expiryDate'],

      // 🌟 قراءة الحقول الجديدة من الـ JSON
      batchNumber: json['batchNumber'] ?? json['BatchNumber'],
      size: json['size'] ?? json['Size'],
      color: json['color'] ?? json['Color'],
      isIngredient: json['isIngredient'] ?? json['IsIngredient'] ?? false,

      ingredients: json['ingredients'],
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
    String? batchNumber,
    String? size,
    String? color,
    bool? isIngredient,
    List<dynamic>? ingredients,
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
      batchNumber: batchNumber ?? this.batchNumber,
      size: size ?? this.size,
      color: color ?? this.color,
      isIngredient: isIngredient ?? this.isIngredient,
      ingredients: ingredients ?? this.ingredients,
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
    batchNumber,
    size,
    color,
    isIngredient,
    ingredients,
    units,
  ];
}