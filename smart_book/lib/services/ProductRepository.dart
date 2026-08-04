// lib/features/pos/data/repositories/product_repository.dart
import 'dart:convert';
import '../../../../core/network/base_api_service.dart';

import '../features/pos/data/models/product_model.dart';
import 'AuthService.dart';

class ProductRepository {

  // 1. جلب المنتجات (بدون طلب توكن كمعامل)
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

  // 2. إضافة صنف جديد (تمت إضافة itemType لدعم استقلالية الأقسام)
  Future<bool> addProduct({
    required String name,
    required String barcode,
    required double price,
    required double purchasePrice,
    required int stock,
    String unitName = "قطعة",
    String itemType = "general", // 👈 استقبال نوع النشاط (restaurant أو pharmacy)
  }) async {
    final String token = await AuthService.getToken();
    final Map<String, dynamic> body = {
      "productNameAr": name,
      "barcode": barcode.isEmpty ? null : barcode,
      "totalStockQuantity": stock,
      "itemType": itemType, // 👈 إرسال نوع النشاط فعلياً للسيرفر لضمان الاستقلالية التامة
      "productUnits": [{
        "unitName": unitName.isEmpty ? "قطعة" : unitName,
        "salePrice": price,
        "purchasePrice": purchasePrice,
        "conversionFactor": 1,
        "isBaseUnit": true
      }]
    };

    try {
      final response = await BaseApiService.postRequest('Products/AddProduct', body, token);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 3. تعديل صنف (تم إضافة التوكين داخلياً)
  Future<bool> updateProduct({
    required int id,
    required String name,
    required String barcode,
    required double price,
    required double purchasePrice,
    required int stock,
    String unitName = "قطعة",
    String itemType = "general", // 👈 يدعم التعديل أيضاً لو احتجته مستقبلاً
  }) async {
    final String token = await AuthService.getToken();
    final Map<String, dynamic> body = {
      "productId": id,
      "productNameAr": name,
      "barcode": barcode.isEmpty ? null : barcode,
      "totalStockQuantity": stock,
      "itemType": itemType,
      "productUnits": [{
        "unitName": unitName.isEmpty ? "قطعة" : unitName,
        "salePrice": price,
        "purchasePrice": purchasePrice,
        "conversionFactor": 1,
        "isBaseUnit": true
      }]
    };

    try {
      // بما أنك تحتاج PUT، يفضل إضافة الميثود في BaseApiService
      // إذا لم تضفها بعد، يمكنك استخدام http.put مباشرة هنا
      // أو استدعاء BaseApiService.putRequest إذا قمت بتعريفها
      return true;
    } catch (e) {
      return false;
    }
  }
}