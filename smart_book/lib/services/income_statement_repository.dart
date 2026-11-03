// lib/features/finance/income_statement/data/repositories/income_statement_repository.dart
import '../../../../core/network/base_api_service.dart';
import '../features/finance/income_statement/data/models/income_statement_model.dart';


class IncomeStatementRepository {

  Future<IncomeStatementModel> getIncomeStatement(DateTime from, DateTime to) async {
    final endpoint = 'FinancialReports/income-statement?fromDate=${from.toIso8601String()}&toDate=${to.toIso8601String()}';

    try {

      final dynamic data = await BaseApiService.getRequest(endpoint);

      return IncomeStatementModel.fromJson(data);
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}