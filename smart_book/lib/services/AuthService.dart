// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
  import 'package:shared_preferences/shared_preferences.dart';
  import '../core/constants/app_config.dart';
  import '../features/auth/models/user_model.dart';

class AuthService {
  static const String _baseUrl = '${AppConfig.baseUrl}/Auth';

  // 1. ميثود داخلية لتقليل تكرار الكود
  static Future<http.Response> _post(String endpoint, Map<String, dynamic> body) async {
    try {
      return await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));
    } catch (e) {
      // في حال فشل الاتصال، نعيد استجابة وهمية لمنع التطبيق من الانهيار
      return http.Response('{"error": "فشل الاتصال بالسيرفر"}', 500);
    }
  }

  // 2. دالة تسجيل الدخول
  static Future<http.Response> login(UserModel loginData) async {
    final response = await _post('login', loginData.toJson());

    // حفظ التوكين في حال كان الدخول ناجحاً
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // تأكد أن مفتاح 'token' في الـ JSON يطابق ما يرسله السيرفر
      if (data.containsKey('token')) {
        await saveToken(data['token']);
      }
    }
    return response;
  }

  // 3. دالة التسجيل
  static Future<http.Response> register(UserModel user) async {
    return await _post('register', user.toJson());
  }

  // 4. إدارة التوكين (حفظ، جلب، حذف)
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}