// lib/features/finance/income_statement/logic/income_statement_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/income_statement_repository.dart';
import 'income_statement_state.dart';

class IncomeStatementCubit extends Cubit<IncomeStatementState> {
  final IncomeStatementRepository repository;

  // حذفنا المتغير report الذي كان مسبباً للخطأ،
  // لأن البيانات يجب أن تأتي من دالة fetch وتُحفظ في الـ State
  IncomeStatementCubit(this.repository) : super(IncomeStatementInitial());

  Future<void> fetchIncomeStatement(DateTime from, DateTime to) async {
    emit(IncomeStatementLoading());
    try {

      final data = await repository.getIncomeStatement(from, to);
      emit(IncomeStatementLoaded(data));
    } catch (e) {
      emit(IncomeStatementError(e.toString()));
    }
  }
}