import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class TrialBalanceItem extends Equatable {
  final String accountCode;
  final String accountName;

  /// مجاميع الحركات
  final double totalDebit;
  final double totalCredit;

  /// الرصيد النهائي
  final double balanceDebit;
  final double balanceCredit;

  const TrialBalanceItem({
    required this.accountCode,
    required this.accountName,
    required this.totalDebit,
    required this.totalCredit,
    required this.balanceDebit,
    required this.balanceCredit,
  });

  factory TrialBalanceItem.fromJson(
      Map<String, dynamic> json,
      ) {
    return TrialBalanceItem(
      accountCode: json['accountCode']?.toString() ?? '',
      accountName: json['accountName']?.toString() ?? 'غير معروف',
      totalDebit: (json['totalDebit'] as num?)?.toDouble() ?? 0.0,
      totalCredit: (json['totalCredit'] as num?)?.toDouble() ?? 0.0,
      balanceDebit: (json['balanceDebit'] as num?)?.toDouble() ?? 0.0,
      balanceCredit: (json['balanceCredit'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountCode': accountCode,
      'accountName': accountName,
      'totalDebit': totalDebit,
      'totalCredit': totalCredit,
      'balanceDebit': balanceDebit,
      'balanceCredit': balanceCredit,
    };
  }

  TrialBalanceItem copyWith({
    String? accountCode,
    String? accountName,
    double? totalDebit,
    double? totalCredit,
    double? balanceDebit,
    double? balanceCredit,
  }) {
    return TrialBalanceItem(
      accountCode:
      accountCode ?? this.accountCode,
      accountName:
      accountName ?? this.accountName,
      totalDebit:
      totalDebit ?? this.totalDebit,
      totalCredit:
      totalCredit ?? this.totalCredit,
      balanceDebit:
      balanceDebit ?? this.balanceDebit,
      balanceCredit:
      balanceCredit ?? this.balanceCredit,
    );
  }

  /// هل الحساب رصيده مدين؟
  bool get hasDebitBalance =>
      balanceDebit > 0;

  /// هل الحساب رصيده دائن؟
  bool get hasCreditBalance =>
      balanceCredit > 0;

  /// هل الحساب متزن (رصيده صفر)
  bool get isBalanced =>
      balanceDebit == 0 &&
          balanceCredit == 0;

  @override
  List<Object> get props => [
    accountCode,
    accountName,
    totalDebit,
    totalCredit,
    balanceDebit,
    balanceCredit,
  ];
}