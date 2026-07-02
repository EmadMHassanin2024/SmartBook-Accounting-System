import '../models/TrialBalanceItem.dart';

abstract class TrialBalanceState {}

class TrialBalanceInitial extends TrialBalanceState {}
class TrialBalanceLoading extends TrialBalanceState {}
class TrialBalanceError extends TrialBalanceState {
  final String message;
  TrialBalanceError(this.message);
}

class TrialBalanceLoaded extends TrialBalanceState {
  final List<TrialBalanceItem> items;
  final double totalDebit;
  final double totalCredit;

  // الحساب يتم داخل الـ Constructor
  TrialBalanceLoaded(this.items)
      : totalDebit = items.fold(0.0, (sum, item) => sum + item.totalDebit),
        totalCredit = items.fold(0.0, (sum, item) => sum + item.totalCredit);
}