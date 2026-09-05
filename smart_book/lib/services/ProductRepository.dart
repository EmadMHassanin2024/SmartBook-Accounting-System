// lib/features/pos/data/repositories/product_repository.dart
import 'dart:convert';
import '../../../../core/network/base_api_service.dart';

import '../features/pos/data/models/product_model.dart';
import '../models/ ProductUnitModel.dart';
import 'AuthService.dart';

class ProductRepository {

  // 1. جلب المنتجات
  Future<List<ProductModel>> fetchProducts() async {
    final String token = await AuthService.getToken();
    try {
      final response = await BaseApiService.getRequest('Products', token);
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedData.map((item) => ProductModel.fromJson(item)).toList();
      }
      throw Exception("فشل جلب المنتجات: ${response.statusCode}");
    } catch (e) {
      throw Exception("خطأ أثناء الاتصال: $e");
    }
  }

  // 2. إضافة صنف جديد مع دعم الوحدات المتعددة
  Future<bool> addProduct({
    required String name,
    required String barcode,
    required double totalStockQuantity,
    required String itemType,
    required List<ProductUnitModel> productUnits,
  }) async {
    final String token = await AuthService.getToken();

    final Map<String, dynamic> body = {
      "ProductNameAr": name,
      "Barcode": barcode.isEmpty ? null : barcode,
      "TotalStockQuantity": totalStockQuantity,
      "ItemType": itemType,
      "ProductUnits": productUnits.map((unit) => unit.toJson()).toList(),
    };

    try {
      final response = await BaseApiService.postRequest('Products/AddProduct', body, token);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 3. تعديل صنف مع دعم الوحدات المتعددة
  Future<bool> updateProduct({
    required int id,
    required String name,
    required String barcode,
    required double totalStockQuantity,
    required String itemType,
    required List<ProductUnitModel> productUnits,
  }) async {
    final String token = await AuthService.getToken();

    final Map<String, dynamic> body = {
      "ProductId": id,
      "ProductNameAr": name,
      "Barcode": barcode.isEmpty ? null : barcode,
      "TotalStockQuantity": totalStockQuantity,
      "ItemType": itemType,
      "ProductUnits": productUnits.map((unit) => unit.toJson()).toList(),
    };

    try {
      final response = await BaseApiService.putRequest('Products/$id', body, token);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  // 4. حذف صنف متوافق مع BaseApiService
  Future<void> deleteProduct(int productId) async {
    final String token = await AuthService.getToken();
    try {
      final response = await BaseApiService.deleteRequest('Products/$productId', token);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل حذف المنتج من الخادم');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }
}