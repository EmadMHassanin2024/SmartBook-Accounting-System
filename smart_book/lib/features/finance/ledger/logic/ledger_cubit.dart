import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/features/finance/ledger/auth_exports.dart';
import '../../repositories/FinancialReportsRepository.dart';


class LedgerCubit extends Cubit<LedgerState> {
  final FinancialReportsRepository repository;

  LedgerCubit(this.repository) : super(const LedgerInitial());

  Future<void> getLedger(int accountId, String from, String to) async {
    emit(const LedgerLoading());

    try {
      // 1. بما أن الـ Repository الآن يرجع List<LedgerTransaction> مباشرة
      final List<LedgerTransaction> transactions =
      await repository.getAccountLedger(accountId, from, to);

      // 2. حساب الرصيد الافتتاحي (اختياري) إذا لم يرسله السيرفر بشكل مستقل
      // يمكن حسابه من أول عنصر في القائمة أو تركه 0.0 إذا كان الـ API لا يرسله
      final double openingBalance = transactions.isNotEmpty
          ? transactions.first.runningBalance - transactions.first.debit + transactions.first.credit
          : 0.0;

      // 3. الإرسال (Emitter)
      emit(LedgerLoaded(
        transactions: transactions,
        openingBalance: openingBalance,
      ));
    } catch (e) {
      // طباعة الخطأ في الكونسول للمساعدة في التصحيح
      print("Error in LedgerCubit: $e");
      emit(LedgerError(e.toString()));
    }
  }
}