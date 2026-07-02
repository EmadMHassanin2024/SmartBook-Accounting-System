// lib/features/finance/income_statement/data/repositories/income_statement_repository.dart
import 'dart:convert';
import '../../../../core/network/base_api_service.dart';
import '../features/finance/income_statement/data/models/income_statement_model.dart';


class IncomeStatementRepository {
  // أصبحنا نستخدم الميثود المركزية من BaseApiService
  // لا نحتاج لكتابة الـ Headers يدوياً في كل Repository

  Future<IncomeStatementModel> getIncomeStatement(DateTime from, DateTime to, String token) async {
    final endpoint = 'FinancialReports/income-statement?fromDate=${from.toIso8601String()}&toDate=${to.toIso8601String()}';

    try {
      final response = await BaseApiService.getRequest(endpoint, token);

      if (response.statusCode == 200) {
        return IncomeStatementModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("فشل تحميل التقرير: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("حدث خطأ أثناء الاتصال بالخادم: $e");
    }
  }
}