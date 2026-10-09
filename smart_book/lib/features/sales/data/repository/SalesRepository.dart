import 'dart:convert';
import 'package:smart_book/features/inventory/auth_exports.dart';
import 'package:http/http.dart' as http;
import '../../../../services/AuthService.dart';

class SalesRepository {
  final http.Client client;
  static const String baseUrl = AppConfig.baseUrl;

  SalesRepository(this.client);

  // دالة جلب تحليلات المبيعات من السيرفر مع التوكن الديناميكي ونوع النشاط
  Future<Map<String, dynamic>> getSalesAnalyticsData({required String activityType}) async {
    try {
      // 1. جلب التوكن المحفوظ محلياً بعد تسجيل الدخول لتجنب خطأ 401
      final token = await AuthService.getToken();

      // 2. بناء الرابط مع تمرير نوع النشاط كـ Query Parameter للفلترة
      final uri = Uri.parse('$baseUrl/Sales/analytics').replace(
        queryParameters: activityType.isNotEmpty ? {'activityType': activityType} : null,
      );

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // إرسال التوكن الحقيقي
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('فشل في جلب تحليلات المبيعات: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء الاتصال بالسيرفر: $e');
    }
  }

  // دالة لجلب الأصناف الأكثر طلباً مع إمكانية تمرير نوع النشاط
  Future<List<dynamic>> getTopProducts({String activityType = ''}) async {
    try {
      final token = await AuthService.getToken();

      final uri = Uri.parse('$baseUrl/Sales/top-products').replace(
        queryParameters: activityType.isNotEmpty ? {'activityType': activityType} : null,
      );

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('فشل في جلب الأصناف الأكثر طلباً');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء الاتصال بالسيرفر: $e');
    }
  }

  // دالة لجلب أفضل العملاء مع إمكانية تمرير نوع النشاط
  Future<List<dynamic>> getTopCustomers({String activityType = ''}) async {
    try {
      final token = await AuthService.getToken();

      final uri = Uri.parse('$baseUrl/Sales/top-customers').replace(
        queryParameters: activityType.isNotEmpty ? {'activityType': activityType} : null,
      );

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('فشل في جلب قائمة أفضل العملاء');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء الاتصال بالسيرفر: $e');
    }
  }
}