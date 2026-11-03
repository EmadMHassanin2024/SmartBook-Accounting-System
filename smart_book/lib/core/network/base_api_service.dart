// lib/core/network/base_api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../features/pos/data/models/product_model.dart';
import '../../services/AuthService.dart';
import '../constants/app_config.dart';

class BaseApiService {

  static Future<Map<String, String>> _getHeaders({bool isAuthRequired = true}) async {
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (isAuthRequired) {
      final token = await AuthService.getToken();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

  // 1. ميثود GET عامة
  static Future<dynamic> getRequest(String endpoint, {bool isAuthRequired = true}) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/$endpoint');
      final headers = await _getHeaders(isAuthRequired: isAuthRequired);

      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } on SocketException {
      throw Exception("لا يوجد اتصال بالإنترنت");
    } catch (e) {
      rethrow;
    }
  }

  // 2. ميثود POST عامة
  static Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body, {bool isAuthRequired = true}) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/$endpoint');
      final headers = await _getHeaders(isAuthRequired: isAuthRequired);

      final response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } on SocketException {
      throw Exception("لا يوجد اتصال بالإنترنت");
    } catch (e) {
      rethrow;
    }
  }

  // 3. ميثود PUT عامة
  static Future<dynamic> putRequest(String endpoint, Map<String, dynamic> body, {bool isAuthRequired = true}) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/$endpoint');
      final headers = await _getHeaders(isAuthRequired: isAuthRequired);

      final response = await http
          .put(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } on SocketException {
      throw Exception("لا يوجد اتصال بالإنترنت");
    } catch (e) {
      rethrow;
    }
  }

  // 4. ميثود DELETE عامة
  static Future<dynamic> deleteRequest(String endpoint, {bool isAuthRequired = true}) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/$endpoint');
      final headers = await _getHeaders(isAuthRequired: isAuthRequired);

      final response = await http.delete(url, headers: headers).timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } on SocketException {
      throw Exception("لا يوجد اتصال بالإنترنت");
    } catch (e) {
      rethrow;
    }
  }

  // مثال على كيفية كتابتها داخل ProductRepository
  Future<List<ProductModel>> fetchProducts() async {
    try {
      // استدعاء الميثود مباشرة بدون إرسال التوكين أو معالجة الـ utf8 يدوياً
      final dynamic data = await BaseApiService.getRequest('Products');

      // تحويل الـ JSON القادم إلى قائمة من الـ ProductModel
      final List<dynamic> decodedData = data as List<dynamic>;
      return decodedData.map((item) => ProductModel.fromJson(item)).toList();

    } catch (e) {
      // الأخطاء (مثل انقطاع النت أو أخطاء السيرفر) يتم التقاطها هنا أو تركها للطبقة الأعلى
      throw Exception("فشل جلب المنتجات: $e");
    }
  }
  // دالة مركزية لمعالجة واستخراج البيانات من الـ Response وقراءة الترميز العربي utf8
  static dynamic _processResponse(http.Response response) {
    final String decodedBody = utf8.decode(response.bodyBytes);

    switch (response.statusCode) {
      case 200:
      case 201:
        return decodedBody.isNotEmpty ? jsonDecode(decodedBody) : null;
      case 400:
        throw Exception("طلب غير صالح: $decodedBody");
      case 401:
      case 403:
        throw Exception("غير مصرح لك بالوصول، يرجى إعادة تسجيل الدخول");
      case 404:
        throw Exception("العنصر المطلوب غير موجود");
      case 500:
      default:
        throw Exception("حدث خطأ في الخادم (Code: ${response.statusCode})");
    }
  }
}