// lib/features/finance/income_statement/data/repositories/income_statement_repository.dart
import 'dart:convert';
import '../../../../../core/network/base_api_service.dart';

import '../../../../../services/AuthService.dart';
import '../models/income_statement_model.dart';

class IncomeStatementRepository {
  // تم حذف التوكين من المعاملات
  Future<IncomeStatementModel> getIncomeStatement(DateTime from, DateTime to) async {

    // 💡 جلب التوكين داخلياً
    final String token = await AuthService.getToken();

    final endpoint = 'FinancialReports/income-statement?fromDate=${from.toIso8601String()}&toDate=${to.toIso8601String()}';

    final response = await BaseApiService.getRequest(endpoint, token);

    if (response.statusCode == 200) {
      return IncomeStatementModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("فشل تحميل التقرير: ${response.statusCode}");
    }
  }
}