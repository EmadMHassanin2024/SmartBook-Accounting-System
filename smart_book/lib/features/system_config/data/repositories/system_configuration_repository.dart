import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_config.dart';
import '../models/system_settings_model.dart';
import 'SystemConfigurationRepository.dart';

class SystemConfigurationRepositoryImpl implements SystemConfigurationRepository {
  static const String baseUrl = AppConfig.baseUrl;

  final _storage = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'SmartBookAuth',
      publicKey: 'SmartBookSecretKey',
    ),
  );
  Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: 'auth_token');

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  @override
  Future<SystemSettingsModel> loadConfiguration() async {
    const String url = '$baseUrl/config'; // استخدمنا final بدلاً من const

    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);
      final Map<String, dynamic> data = decodedBody is Map<String, dynamic>
          ? (decodedBody.containsKey('data') ? decodedBody['data'] : decodedBody)
          : {};

      return SystemSettingsModel.fromJson(data);
    } else {
      throw Exception("فشل تحميل الإعدادات: ${response.statusCode}");
    }
  }

  @override
  Future<void> saveConfiguration(SystemSettingsModel settings) async {
    const String url = '$baseUrl/config';

    final response = await http.post(
      Uri.parse(url),
      headers: await _getHeaders(),
      body: json.encode(settings.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw Exception("فشل حفظ الإعدادات: ${response.statusCode} - ${response.body}");
    }
  }
}