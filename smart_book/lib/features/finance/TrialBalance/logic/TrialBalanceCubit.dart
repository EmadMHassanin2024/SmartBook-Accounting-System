import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/FinancialReportsRepository.dart';
import 'TrialBalanceState.dart';

class TrialBalanceCubit extends Cubit<TrialBalanceState> {
  final FinancialReportsRepository repository;

  TrialBalanceCubit(this.repository) : super(TrialBalanceInitial());

  Future<void> fetchTrialBalance(DateTime date) async {
    emit(TrialBalanceLoading());
    try {
      final data = await repository.getTrialBalance(date);
      emit(TrialBalanceLoaded(data));
    } catch (e) {
      emit(TrialBalanceError(e.toString()));
    }
  }
}