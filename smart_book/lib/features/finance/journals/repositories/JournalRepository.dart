import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_config.dart';
import '../../../invoices/models/invoice_model.dart';
import '../../accounting/models/JournalDetailModel.dart';
import '../models/JournalModel.dart';

class JournalRepository {
  static const String baseUrl = AppConfig.baseUrl;

  final _storage = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'SmartBookAuth',
      publicKey: 'SmartBookSecretKey',
    ),
  );

  // 1. جلب كافة القيود
  Future<List<JournalModel>> getAllJournals() async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse('$baseUrl/JournalEntries'),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((json) => JournalModel.fromJson(json)).toList();
      }
      throw Exception("فشل الاتصال: ${response.statusCode}");
    } catch (e) {
      throw Exception("خطأ أثناء جلب القيود: $e");
    }
  }

  // 2. إنشاء قيد تلقائي من فاتورة
  Future<void> createAutomaticJournalFromInvoice(InvoiceModel invoice) async {
    try {
      final List<JournalDetailModel> journalDetails = [
        JournalDetailModel(accountId: 1, accountName: "النقدية", debit: invoice.totalAmount, credit: 0.0, description: 'تحصيل فاتورة'),
        JournalDetailModel(accountId: 3, accountName: "المبيعات", debit: 0.0, credit: invoice.subTotal, description: 'مبيعات'),
        JournalDetailModel(accountId: 4, accountName: "ضريبة القيمة المضافة", debit: 0.0, credit: invoice.tax, description: 'ضريبة'),
      ];

      final journal = JournalModel(
        entryId: 0,
        description: "قيد أوتوماتيكي للفاتورة رقم: ${invoice.invoiceNumber}",
        entryDate: invoice.date,
        totalDebit: invoice.totalAmount,
        totalCredit: invoice.totalAmount,
        details: journalDetails,
      );

      await saveJournal(journal);
    } catch (e) {
      throw Exception("خطأ في إنشاء القيد التلقائي: $e");
    }
  }

  // 3. حفظ قيد جديد (ترحيل)
  Future<bool> saveJournal(JournalModel journal) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      final response = await http.post(
        Uri.parse('$baseUrl/JournalEntries'),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        // تأكد من تحويل التفاصيل إلى JSON
        body: json.encode({
          "entryDate": journal.entryDate,
          "description": journal.description,
          "details": journal.details.map((d) => d.toJson()).toList(),
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception("خطأ أثناء ترحيل القيد: $e");
    }
  }

  // 4. تعديل قيد
  Future<bool> updateJournal(int entryId, JournalModel journal) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      final response = await http.put(
        Uri.parse('$baseUrl/JournalEntries/$entryId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "entryDate": journal.entryDate,
          "description": journal.description,
          "details": journal.details.map((d) => d.toJson()).toList(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception("خطأ أثناء تعديل القيد: $e");
    }
  }
/*
  // 5. جلب دفتر الأستاذ (الأكثر أهمية في حالتك)
  Future<Map<String, dynamic>> getAccountLedger(int accountId, String fromDate, String toDate) async {
    String? token = await _storage.read(key: 'auth_token');

    // تأكد أن المسار هو JournalEntries/Ledger
    final String url = '$baseUrl/FinancialReports/Ledger?accountId=$accountId&from=$fromDate&to=$toDate';

    print("طلب الـ API الموجه للسيرفر: $url"); // 💡 هام جداً للـ Debugging

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // إذا ظهر 404 هنا، فهذا يعني أن baseUrl في AppConfig يحتاج لتعديل
      throw Exception("خطأ ${response.statusCode}: ${response.body}");
    }
  }

 */

  // 6. حذف قيد
  Future<bool> deleteJournal(int entryId) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      final response = await http.delete(
        Uri.parse('$baseUrl/JournalEntries/$entryId'),
        headers: {"Authorization": "Bearer $token"},
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception("خطأ أثناء حذف القيد: $e");
    }
  }
}