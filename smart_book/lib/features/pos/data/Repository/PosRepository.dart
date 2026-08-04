// lib/features/pos/data/repositories/pos_repository.dart
import 'dart:convert';
import '../../../../../../../core/network/base_api_service.dart';


import '../../../../core/models/product_model.dart';


import '../../../../services/AuthService.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class PosRepository {

  // 1. ترحيل الفاتورة
  Future<bool> saveInvoice(List<CartItemModel> cartItems, String paymentType) async {
    if (cartItems.isEmpty) return false;

    final String token = await AuthService.getToken();

    // حساب الإجماليات محلياً لتتوافق مع الـ DTO
    double subTotal = cartItems.fold(0.0, (sum, item) => sum + item.subTotal);
    double vatAmount = subTotal * 0.15;
    double totalAmount = subTotal + vatAmount;

    final Map<String, dynamic> requestBody = {
      "invoiceDate": DateTime.now().toIso8601String(),
      "totalAmount": totalAmount,
      "paymentType": paymentType,
      "description": "فاتورة صادرة من تطبيق فلاتر - SmartBook",
      // تأكد أن المفتاح هو "items" ليتطابق مع List<InvoiceItemDto> Items في الـ C#
      "items": cartItems.map((item) => {
        "productId": int.tryParse(item.product.id.toString()) ?? 0,
        "quantity": item.quantity,
        "unitPrice": (item.product.price as num).toDouble(),
        "vatAmount": (item.vatAmount as num).toDouble(),
      }).toList(),
    };

    try {
      final response = await BaseApiService.postRequest('Pos/save-invoice', requestBody, token);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 2. جلب جميع المنتجات
  Future<List<ProductModel>> getAllProducts() async {
    final String token = await AuthService.getToken(); // 💡 جلب التوكين داخلياً
    try {
      final response = await BaseApiService.getRequest('Products', token);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
      throw Exception("فشل جلب المنتجات");
    } catch (e) {
      throw Exception("خطأ أثناء جلب المنتجات: $e");
    }
  }

  // 3. جلب الفواتير
  Future<List<dynamic>> getAllInvoices() async {
    final String token = await AuthService.getToken(); // 💡 جلب التوكين داخلياً
    try {
      final response = await BaseApiService.getRequest('Invoices', token);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}