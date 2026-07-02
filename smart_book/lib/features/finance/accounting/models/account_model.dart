import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final int accountId;
  final String accountCode;
  final String accountName;
  final String accountType;
  final int? parentAccountId;
  final bool isMain;
  final double currentBalance;
  final List<AccountModel> children;

  const AccountModel({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.accountType,
    this.parentAccountId,
    required this.isMain,
    required this.currentBalance,
    this.children = const [],
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {

    return AccountModel(
      // نقرأ الحقل إذا كان مكتوباً بأي طريقة (كبير أو صغير)
      accountId: (json['accountId'] ?? json['AccountId'] ?? 0) as int,
      accountCode: (json['accountCode'] ?? json['AccountCode'] ?? '').toString(),
      accountName: (json['accountNameAr'] ?? json['AccountNameAr'] ?? 'بدون اسم').toString(),
      accountType: (json['accountType'] ?? json['AccountType'] ?? 0).toString(),
      currentBalance: (json['currentBalance'] ?? json['CurrentBalance'] ?? 0.0).toDouble(),
      isMain: json['isMain'] ?? json['IsMain'] ?? false,
      parentAccountId: json['parentAccountId'] ?? json['ParentAccountID'],
      children: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccountID': accountId,
      'AccountCode': accountCode,
      'AccountNameAr': accountName,
      'AccountType': accountType,
      'ParentAccountID': parentAccountId,
      'IsMain': isMain ? 1 : 0,
      'CurrentBalance': currentBalance,
      'children': children.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    accountId,
    accountCode,
    accountName,
    accountType,
    parentAccountId,
    isMain,
    currentBalance,
    children,
  ];
}