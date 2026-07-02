// lib/features/finance/income_statement/logic/income_statement_state.dart
import 'package:equatable/equatable.dart';

import '../data/models/income_statement_model.dart';



abstract class IncomeStatementState extends Equatable {
  const IncomeStatementState();
  @override
  List<Object> get props => [];
}

class IncomeStatementInitial extends IncomeStatementState {}
class IncomeStatementLoading extends IncomeStatementState {}
class IncomeStatementLoaded extends IncomeStatementState {
  final IncomeStatementModel model;
  const IncomeStatementLoaded(this.model);
  @override
  List<Object> get props => [model];
}
class IncomeStatementError extends IncomeStatementState {
  final String message;
  const IncomeStatementError(this.message);
  @override
  List<Object> get props => [message];
}