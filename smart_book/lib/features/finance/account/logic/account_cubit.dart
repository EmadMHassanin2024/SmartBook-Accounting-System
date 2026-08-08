import 'package:flutter_bloc/flutter_bloc.dart';

import '../../accounting/models/account_model.dart';
import '../../repositories/FinancialReportsRepository.dart';

import 'AccountState.dart';


class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}

// الـ Cubit المسؤول عن جلب الحسابات
class AccountCubit extends Cubit<AccountState> {
  final FinancialReportsRepository  repository;

  AccountCubit(this.repository) : super(AccountInitial());

  Future<void> fetchAccounts() async {
    emit(AccountLoading());
    try {
      final accounts = await repository.getAccounts();
      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}