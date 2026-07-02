class ProductUnitModel {
  final int? unitId;
  String unitName; // جعلتها قابلة للتعديل لسهولة الاستخدام في الشاشات
  double salePrice;
  double purchasePrice;
  double conversionFactor;
  final bool isBaseUnit;

  ProductUnitModel({
    this.unitId,
    required this.unitName,
    required this.salePrice,
    required this.purchasePrice,
    required this.conversionFactor,
    required this.isBaseUnit,
  });

  factory ProductUnitModel.fromJson(Map<String, dynamic> json) {
    return ProductUnitModel(
      unitName: json['unitName'] ?? '',
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      conversionFactor: (json['conversionFactor'] as num?)?.toDouble() ?? 1.0,
      isBaseUnit: json['isBaseUnit'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unitName': unitName,
      'salePrice': salePrice,
      'purchasePrice': purchasePrice,
      'conversionFactor': conversionFactor,
      'isBaseUnit': isBaseUnit,
    };
  }
}