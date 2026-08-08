
import 'package:smart_book/features/inventory/auth_exports.dart';

import 'package:http/http.dart' as http;


class InventoryRepository {
  late final http.Client client; // 1. أضف هذا المتغير
  static const String baseUrl = AppConfig.baseUrl;

  // TODO
  static const String _token = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI3IiwidW5pcXVlX25hbWUiOiJlbWFkMjAyNiIsIm5iZiI6MTc4MTAyNjQwNCwiZXhwIjoxNzgxMTEyODA0LCJpYXQiOjE3ODEwMjY0MDQsImlzcyI6IlNtYXJ0Qm9va0FQSSIsImF1ZCI6IlNtYXJ0Qm9va1VzZXJzIn0.j0SumDqMGU5QZ9dRMPBaQ2yCvLKB_Kbfv0QTl4sYQJMM4MA9h1pA4DhcUEFnKeWFccLGaWufRGKlPPs6u4CXyA";

  InventoryRepository(http.Client client);

  // دالة إرسال عملية الجرد للسيرفر
  Future<bool> saveAdjustment(InventoryTransaction transaction) async {

    try {


      final response = await http.post(
        Uri.parse('$baseUrl/Products/adjust-stock'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode(transaction.toJson()),


      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {

        throw Exception('فشل في حفظ عملية الجرد: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء الاتصال بالسيرفر: $e');
    }


  }

  // يمكنك إضافة دالة لجلب سجل عمليات الجرد لاحقاً هنا بنفس الأسلوب
  Future<List<dynamic>> getInventoryHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/inventory/Products/adjust-stock'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('فشل في جلب سجل الجرد');
    }
  }
}