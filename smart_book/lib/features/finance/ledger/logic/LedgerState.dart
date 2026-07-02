import 'package:equatable/equatable.dart';
import '../models/ledger_transaction_model.dart';

abstract class LedgerState extends Equatable {
  const LedgerState();

  @override
  List<Object?> get props => [];
}

class LedgerInitial extends LedgerState {
  const LedgerInitial();
}

class LedgerLoading extends LedgerState {
  const LedgerLoading();
}

class LedgerLoaded extends LedgerState {
  final List<LedgerTransaction> transactions;
  final double openingBalance;

  const LedgerLoaded({
    required this.transactions,
    required this.openingBalance,
  });

  @override
  List<Object?> get props => [transactions, openingBalance];
}

class LedgerError extends LedgerState {
  final String message;

  const LedgerError(this.message);

  @override
  List<Object?> get props => [message];
}