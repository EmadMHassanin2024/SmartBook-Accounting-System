import 'package:equatable/equatable.dart';

// 🎯 استخدام Equatable لضمان أداء عالٍ في الـ BLoC وتجنب الـ Rebuild غير الضروري
class ProductModel extends Equatable {
  final int id;
  final String name;
  final String barcode;
  final double price;
  final double stock;         // 💡 تمت الإضافة والتأكيد على أنها final
  final double purchasePrice;
  final String imagePath;
  // 🌟 الإضافات الجديدة لضمان مرونة النموذج مع كافة أنواع المخزون:
  final String itemType;       // نوع الصنف (مثلاً: general, restaurant_meal, medicine, etc.)
  final String? expiryDate;    // تاريخ الصلاحية (مهم للأغذية والصيدليات)
  final List<dynamic>? ingredients; // مكونات الوجبة (خاص بالمطاعم للربط بالمخزون)

  const ProductModel({
    required this.id,
    required this.name,
    required this.barcode,
    required this.price,
    required this.stock,
    required this.purchasePrice,
    required this.imagePath, this.itemType = 'general'
    , this.expiryDate,
    this.ingredients,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double salePrice = 0.0;
    double purchasePrice = 0.0;

    if (json['productUnits'] != null && (json['productUnits'] as List).isNotEmpty) {
      var firstUnit = json['productUnits'][0];
      salePrice = (firstUnit['salePrice'] as num?)?.toDouble() ?? 0.0;
      purchasePrice = (firstUnit['purchasePrice'] as num?)?.toDouble() ?? 0.0;
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
    );
  }

  // 🎯 دالة copyWith: أساسية لتحديث الحالة في الـ Cubit بسهولة وأمان
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
    );
  }

  // 🎯 تعريف الخصائص التي تهمنا في المقارنة (عند تغير الـ stock سيتحدث الـ UI فوراً)
  @override
  List<Object?> get props => [id, name,
    barcode, price, stock, purchasePrice, imagePath,

    itemType,
    expiryDate,
    ingredients,
  ];
}