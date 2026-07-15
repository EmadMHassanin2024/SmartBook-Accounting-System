import 'dart:convert';

import '../../../core/models/product_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_config.dart';


class ProductRepository {
  final http.Client _client;

  static const String baseUrl = AppConfig.baseUrl;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ProductRepository(this._client);

  /// ===========================
  /// Headers
  /// ===========================
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'auth_token');

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// ===========================
  /// Get All Products
  /// ===========================
  Future<List<ProductModel>> getProducts() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/Products'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      "فشل في جلب المنتجات (${response.statusCode})",
    );
  }

  /// ===========================
  /// Add Product
  /// ===========================
  Future<void> addProduct(ProductModel product) async {
    final payload = jsonEncode(product.toJson());
    print("DEBUG: Sending JSON -> $payload"); // <--- هذا السطر سيكشف كل شيء

    final response = await _client.post(
      Uri.parse('$baseUrl/Products/AddProduct'),
      headers: await _getHeaders(),
      body: payload,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      // أضف هذا السطر لتعرف لماذا رفض السيرفر الطلب
      print("SERVER ERROR BODY: ${response.body}");
      throw Exception("فشل إضافة المنتج (${response.statusCode})");
    }
  }

  /// ===========================
  /// Update Product
  /// ===========================
  Future<void> updateProduct(ProductModel product) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/Products/${product.productId}'),
      headers: await _getHeaders(),
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw Exception(
        "فشل تعديل المنتج (${response.statusCode})",
      );
    }
  }

  /// ===========================
  /// Delete Product
  /// ===========================
  Future<void> deleteProduct(int productId) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/Products/$productId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw Exception(
        "فشل حذف المنتج (${response.statusCode})",
      );
    }
  }
}