import 'package:equatable/equatable.dart';

class LedgerTransaction extends Equatable {
  final int entryId;
  final DateTime date;
  final String contraAccountName;
  final String description;
  final double debit;
  final double credit;
  final double runningBalance;

  const LedgerTransaction({
    required this.entryId,
    required this.date,
    required this.contraAccountName,
    required this.description,
    required this.debit,
    required this.credit,
    required this.runningBalance,
  });


  factory LedgerTransaction.fromJson(Map<String, dynamic> json) {
    //print("DEBUG LEDGER JSON: $json");
    return LedgerTransaction(
      entryId: (json['entryId'] as num?)?.toInt() ?? 0,
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      description: json['description']?.toString() ?? '',
      contraAccountName: json['contraAccountName']?.toString() ?? '',
      debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      runningBalance: (json['runningBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entryId': entryId,
      'date': date.toIso8601String(),
      'description': description,
      'contraAccountName': contraAccountName,
      'debit': debit,
      'credit': credit,
      'runningBalance': runningBalance,
    };
  }

  LedgerTransaction copyWith({
    int? entryId,
    DateTime? date,
    String? contraAccountName,
    String? description,
    double? debit,
    double? credit,
    double? runningBalance,
  }) {
    return LedgerTransaction(
      entryId: entryId ?? this.entryId,
      date: date ?? this.date,
      contraAccountName: contraAccountName ?? this.contraAccountName,
      description: description ?? this.description,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      runningBalance: runningBalance ?? this.runningBalance,
    );
  }

  @override
  List<Object> get props => [
    entryId,
    date,
    contraAccountName,
    description,
    debit,
    credit,
    runningBalance,
  ];
}