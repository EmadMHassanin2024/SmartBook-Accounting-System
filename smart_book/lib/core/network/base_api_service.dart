// lib/core/network/base_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_config.dart';

class BaseApiService {
  // ميثود GET عامة
  static Future<http.Response> getRequest(String endpoint, String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/$endpoint');
    return await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    ).timeout(const Duration(seconds: 30));
  }

  // ميثود POST عامة
  static Future<http.Response> postRequest(String endpoint, Map<String, dynamic> body, String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/$endpoint');
    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 30));
  }

// ميثود PUT عامة
  static Future<http.Response> putRequest(String endpoint, Map<String, dynamic> body, String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/$endpoint');
    return await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 30));
  }


  // ميثود DELETE عامة
  static Future<http.Response> deleteRequest(String endpoint, String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/$endpoint');
    return await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    ).timeout(const Duration(seconds: 30));
  }
}