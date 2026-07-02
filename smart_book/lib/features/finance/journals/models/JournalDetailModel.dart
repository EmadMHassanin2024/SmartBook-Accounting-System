import 'package:equatable/equatable.dart';

class JournalDetailModel extends Equatable {
  final int accountId;
  final String accountName;
  final double debit;
  final double credit;

  const JournalDetailModel({
    required this.accountId,
    required this.accountName,
    required this.debit,
    required this.credit,
  });

  factory JournalDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return JournalDetailModel(
      accountId: json['accountId'] ?? 0,
      accountName: json['accountName'] ?? '',
      debit: (json['debit'] as num?)?.toDouble() ?? 0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'accountName': accountName,
      'debit': debit,
      'credit': credit,
    };
  }

  @override
  List<Object?> get props => [
    accountId,
    accountName,
    debit,
    credit,
  ];
}