import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum AdjustmentType {
  accrued,
  prepaid,
  depreciation,
}

@immutable
class AdjustmentEntry extends Equatable {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final AdjustmentType type;

  const AdjustmentEntry({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });

  factory AdjustmentEntry.fromJson(
      Map<String, dynamic> json,
      ) {
    return AdjustmentEntry(
      id: json['id']?.toString() ?? '',
      description:
      json['description']?.toString() ?? '',
      amount:
      (json['amount'] as num?)
          ?.toDouble() ??
          0.0,
      date: DateTime.tryParse(
        json['date']?.toString() ?? '',
      ) ??
          DateTime.now(),
      type: _parseType(
        json['type']?.toString(),
      ),
    );
  }

  static AdjustmentType _parseType(
      String? value,
      ) {
    switch (value?.toLowerCase()) {
      case 'accrued':
        return AdjustmentType.accrued;

      case 'prepaid':
        return AdjustmentType.prepaid;

      case 'depreciation':
        return AdjustmentType.depreciation;

      default:
        return AdjustmentType.accrued;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
    };
  }

  AdjustmentEntry copyWith({
    String? id,
    String? description,
    double? amount,
    DateTime? date,
    AdjustmentType? type,
  }) {
    return AdjustmentEntry(
      id: id ?? this.id,
      description:
      description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  bool get isAccrued =>
      type == AdjustmentType.accrued;

  bool get isPrepaid =>
      type == AdjustmentType.prepaid;

  bool get isDepreciation =>
      type == AdjustmentType.depreciation;

  @override
  List<Object?> get props => [
    id,
    description,
    amount,
    date,
    type,
  ];
}