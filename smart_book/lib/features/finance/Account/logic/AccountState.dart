// حالات الـ Cubit
import 'package:smart_book/features/finance/accounting/models/account_model.dart';



abstract class AccountState {}
class AccountInitial extends AccountState {}
class AccountLoading extends AccountState {}
class AccountLoaded extends AccountState {
  final List<AccountModel> accounts;
  AccountLoaded(this.accounts);
}