import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_config.dart';
import '../../../core/models/product_model.dart';
import '../models/inventory_transaction.dart';

class InventoryRepository {

  static const String baseUrl = AppConfig.baseUrl;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client client;

  InventoryRepository(this.client);

  /// دالة خاصة لجلب الهيدرز مع التوكين الديناميكي
  Future<Map<String, String>> _getHeaders() async {

    final token = await _storage.read(key: 'auth_token');

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

  }

  /// 1. جلب قائمة المنتجات
  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/Products'),
      headers: await _getHeaders(),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    throw Exception(
      "فشل في جلب المنتجات (${response.statusCode})\n${response.body}",
    );
  }
  /// 2. حفظ تسوية جرد (تم دمجها وتوحيدها)
  Future<bool> saveAdjustment(InventoryTransaction transaction) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Products/adjust-stock'),
      headers: await _getHeaders(),

      body: json.encode(transaction.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('فشل في حفظ عملية الجرد: ${response.statusCode}');
    }
  }

  /// 3. جلب سجل تاريخ الجرد
  Future<List<dynamic>> getInventoryHistory() async {
    final response = await client.get(
      Uri.parse('$baseUrl/inventory/Products/adjust-stock'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          """
Status Code : ${response.statusCode}

Body :

${response.body}
""");
    }
  }


}