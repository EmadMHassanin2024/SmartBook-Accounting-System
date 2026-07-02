
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class IncomeStatementItem extends Equatable {
  final String accountName;
  final double amount;

  const IncomeStatementItem({
    required this.accountName,
    required this.amount
  });

  factory IncomeStatementItem.fromJson(Map<String, dynamic> json) {
    return IncomeStatementItem(
      accountName: json['accountName'] ?? '',
      amount: (json['amount'] as num).toDouble(),
    );
  }

  // إضافة toJson عند الحاجة لإرسال بيانات من التطبيق للـ API
  Map<String, dynamic> toJson() {
    return {
      'accountName': accountName,
      'amount': amount,
    };
  }

  @override
  List<Object?> get props => [accountName, amount];
}