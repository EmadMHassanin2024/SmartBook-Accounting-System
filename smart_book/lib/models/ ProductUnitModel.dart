
import '../features/inventory/auth_exports.dart';

class ProductUnitModel extends Equatable {
  final int? unitId;
  final String unitName;
  final double salePrice;
  final double purchasePrice;
  final double conversionFactor;
  final bool isBaseUnit;

  const ProductUnitModel({
    this.unitId,
    required this.unitName,
    required this.salePrice,
    required this.purchasePrice,
    required this.conversionFactor,
    required this.isBaseUnit,
  });

  // ⭐ MODIFIED: قراءة الوحدة من API
  factory ProductUnitModel.fromJson(Map<String, dynamic> json) {
    return ProductUnitModel(
      unitId: json['unitId'],
      unitName: json['unitName'] ?? 'قطعة',
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      purchasePrice:
      (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      conversionFactor:
      (json['conversionFactor'] as num?)?.toDouble() ?? 1.0,
      isBaseUnit: json['isBaseUnit'] == true,
    );
  }

  // ⭐ MODIFIED: إرسال الوحدة إلى API
  Map<String, dynamic> toJson() {
    return {
      if (unitId != null) 'unitId': unitId,
      'unitName': unitName,
      'salePrice': salePrice,
      'purchasePrice': purchasePrice,
      'conversionFactor': conversionFactor,
      'isBaseUnit': isBaseUnit,
    };
  }

  @override
  List<Object?> get props => [
    unitId,
    unitName,
    salePrice,
    purchasePrice,
    conversionFactor,
    isBaseUnit,
  ];
}