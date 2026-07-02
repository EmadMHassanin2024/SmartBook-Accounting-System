import 'dart:convert';
import 'package:flutter/material.dart'; // ضرورية لـ debugPrint
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_config.dart';
import '../../../core/packages.dart';
import '../TrialBalance/models/TrialBalanceItem.dart';
import '../accounting/models/account_model.dart';
import '../adjustments/models/adjustment_entry.dart';
// 💡 تأكد من استيراد الموديل الخاص بالحركات (يرجى التأكد من المسار الصحيح)
import '../ledger/models/ledger_transaction_model.dart';

class FinancialReportsRepository {
  static const String baseUrl = AppConfig.baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: 'auth_token');
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // 1. ميزان المراجعة
  Future<List<TrialBalanceItem>> getTrialBalance(DateTime date) async {
    final response = await http.get(
      Uri.parse('$baseUrl/FinancialReports/trial-balance?date=${date.toIso8601String()}'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => TrialBalanceItem.fromJson(json)).toList();
    }
    throw Exception("فشل جلب ميزان المراجعة: ${response.statusCode}");
  }

  // 2. قيود التسويات
  Future<List<AdjustmentEntry>> getAdjustments(DateTime date) async {
    final response = await http.get(
      Uri.parse('$baseUrl/FinancialReports/adjustments?date=${date.toIso8601String()}'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AdjustmentEntry.fromJson(json)).toList();
    }
    throw Exception("فشل جلب التسويات: ${response.statusCode}");
  }

  // 3. جلب الحسابات
  Future<List<AccountModel>> getAccounts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/FinancialReports/Accounts'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final List<dynamic> dataList = responseBody['data'] as List<dynamic>;
      return dataList.map((json) => AccountModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception("فشل جلب الحسابات: ${response.statusCode}");
    }
  }

  // 4. حفظ التسويات
  Future<void> saveAdjustment(AdjustmentEntry transaction) async {
    final response = await http.post(
      Uri.parse('$baseUrl/FinancialReports/adjustments/save'),
      headers: await _getHeaders(),
      body: json.encode(transaction.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint("Server Error: ${response.body}");
      throw Exception("فشل حفظ التسوية: ${response.statusCode}");
    }
  }

  // 5. جلب دفتر الأستاذ (تم التعديل للتعامل مع هيكل JSON الجديد)
  Future<List<LedgerTransaction>> getAccountLedger(int accountId, String fromDate, String toDate) async {
    final String url = '$baseUrl/FinancialReports/Ledger?accountId=$accountId&from=$fromDate&to=$toDate';

    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      // هنا نقوم بفك التشفير والتعامل مع الغلاف
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // نصل للقائمة الموجودة داخل مفتاح "data"
      final List<dynamic> dataList = responseBody['data'] as List<dynamic>? ?? [];

      // نحولها إلى قائمة من الموديلات
      return dataList.map((json) => LedgerTransaction.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception("خطأ ${response.statusCode}: ${response.body}");
    }
  }
}