
import 'package:equatable/equatable.dart';

import '../../../../core/packages.dart';
import '../../../../models/ ProductUnitModel.dart';


class ProductModel extends Equatable {
  final int id;
  final String name;
  final String barcode;
  final double price;
  final double stock;
  final double purchasePrice;
  final String imagePath;
  final double? reorderLevel;

  // نوع النشاط
  final String itemType;

  // بيانات الصلاحية والتشغيل
  final String? expiryDate;
  final String? batchNumber;

  // خصائص إضافية
  final String? size;
  final String? color;
  final bool isIngredient;
  final List<dynamic>? ingredients;

  // وحدات المنتج
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
    this.reorderLevel = 5.0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // 1. قراءة وحدات المنتج بأمان
    final List<ProductUnitModel> units = [];

    final rawUnits = json['productUnits'];

    if (rawUnits is List) {
      for (final item in rawUnits) {
        if (item is Map) {
          try {
            final unitJson = Map<String, dynamic>.from(item);

            units.add(ProductUnitModel.fromJson(unitJson));
          } catch (_) {
            // تجاهل الوحدة غير الصالحة بدلاً من تعطيل تحميل الأصناف
            continue;
          }
        }
      }
    }

    // 2. تحديد الوحدة الأساسية
    ProductUnitModel? baseUnit;

    for (final unit in units) {
      if (unit.isBaseUnit) {
        baseUnit = unit;
        break;
      }
    }

    // إذا لم توجد وحدة أساسية نستخدم أول وحدة
    baseUnit ??= units.isNotEmpty ? units.first : null;

    // 3. قراءة الأسعار
    final double salePrice = baseUnit?.salePrice ??
        _toDouble(
          json['salePrice'] ??
              json['sellingPrice'] ??
              json['price'],
        );

    final double purchasePrice = baseUnit?.purchasePrice ??
        _toDouble(
          json['purchasePrice'] ??
              json['buyPrice'],
        );

    // 4. قراءة المخزون
    final double stockVal = _toDouble(
      json['totalStockQuantity'] ?? json['stock'],
    );

    // 5. حد إعادة الطلب
    final double reorderVal = _toDouble(
      json['reorderLevel'] ?? json['ReorderLevel'],
      fallback: 5.0,
    );

    // 6. قراءة المكونات
    final rawIngredients = json['ingredients'];

    final List<dynamic>? ingredients =
    rawIngredients is List
        ? List<dynamic>.from(rawIngredients)
        : null;

    // 7. إنشاء الموديل
    return ProductModel(
      id: _toInt(json['productId'] ?? json['id']),
      name: _toString(
        json['productNameAr'] ?? json['name'],
        fallback: 'صنف بدون اسم',
      ),
      barcode: _toString(json['barcode']),
      price: salePrice,
      purchasePrice: purchasePrice,
      stock: stockVal,
      imagePath: _toString(json['imagePath']),
      itemType: _toString(
        json['itemType'],
        fallback: 'general',
      ),
      expiryDate: _toNullableString(json['expiryDate']),
      batchNumber: _toNullableString(
        json['batchNumber'] ?? json['BatchNumber'],
      ),
      size: _toNullableString(
        json['size'] ?? json['Size'],
      ),
      color: _toNullableString(
        json['color'] ?? json['Color'],
      ),
      isIngredient: _toBool(
        json['isIngredient'] ?? json['IsIngredient'],
      ),
      ingredients: ingredients,
      reorderLevel: reorderVal,
      units: List.unmodifiable(units),
    );
  }

  // تحويل آمن إلى int
  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  // تحويل آمن إلى double
  static double _toDouble(
      dynamic value, {
        double fallback = 0.0,
      }) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  // تحويل آمن إلى String
  static String _toString(
      dynamic value, {
        String fallback = '',
      }) {
    if (value == null) return fallback;
    return value.toString();
  }

  // تحويل القيم الاختيارية إلى String
  static String? _toNullableString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  // معالجة bool سواء رجعت Boolean أو 0/1 أو String
  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      return normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes';
    }

    return false;
  }

  // 8. تحديث الموديل دون فقد البيانات
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
    double? reorderLevel,

    // السماح بمسح القيم الاختيارية صراحة
    bool clearExpiryDate = false,
    bool clearBatchNumber = false,
    bool clearSize = false,
    bool clearColor = false,
    bool clearIngredients = false,
    bool clearReorderLevel = false,
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

      expiryDate: clearExpiryDate
          ? null
          : expiryDate ?? this.expiryDate,

      batchNumber: clearBatchNumber
          ? null
          : batchNumber ?? this.batchNumber,

      size: clearSize ? null : size ?? this.size,
      color: clearColor ? null : color ?? this.color,

      isIngredient: isIngredient ?? this.isIngredient,

      ingredients: clearIngredients
          ? null
          : ingredients ?? this.ingredients,

      units: units ?? this.units,

      reorderLevel: clearReorderLevel
          ? null
          : reorderLevel ?? this.reorderLevel,
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
    reorderLevel,
  ];
}
