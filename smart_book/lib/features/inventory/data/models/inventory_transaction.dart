import 'package:equatable/equatable.dart';

class InventoryTransaction extends Equatable {
  final String productId;
  final int physicalCount;
  final String note;
  final DateTime date;

  const InventoryTransaction({
    required this.productId,
    required this.physicalCount,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    "productId": int.parse(productId),
    "newStock": physicalCount,
    "note": note,
    "date": date.toIso8601String(),
  };

  @override
  List<Object?> get props => [productId, physicalCount, note, date];
}