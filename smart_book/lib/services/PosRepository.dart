// lib/features/pos/data/repositories/pos_repository.dart
import '../../../../core/network/base_api_service.dart';
import '../features/pos/data/models/cart_item_model.dart';
import '../features/pos/data/models/product_model.dart';


class PosRepository {

  // 1. ترحيل الفاتورة
  Future<bool> saveInvoice(List<CartItemModel> cartItems, String paymentType) async {
    if (cartItems.isEmpty) return false;

    double subTotal = cartItems.fold(0.0, (sum, item) => sum + item.subTotal);
    double vatAmount = subTotal * 0.15;
    double totalAmount = subTotal + vatAmount;

    final Map<String, dynamic> requestBody = {
      "invoiceDate": DateTime.now().toIso8601String(),
      "totalAmount": totalAmount,
      "paymentType": paymentType,
      "description": "فاتورة صادرة من تطبيق فلاتر SmartBook",
      "items": cartItems.map((item) => {
        "productId": int.tryParse(item.product.id.toString()) ?? 0,
        "quantity": item.quantity,
        "unitPrice": item.product.price,
        "vatAmount": item.vatAmount,
      }).toList(),
    };

    try {
      // BaseApiService يتولى التوكين وفحص الاستجابة تلقائياً
      await BaseApiService.postRequest('Pos/save-invoice', requestBody);
      return true;
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  // 2. جلب جميع المنتجات
  Future<List<ProductModel>> getAllProducts() async {
    try {
      // BaseApiService يرجع الـ JSON مفكوك وجاهز (Dynamic)
      final dynamic data = await BaseApiService.getRequest('Products');

      final List<dynamic> list = data as List<dynamic>;
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  // 3. جلب الفواتير
  Future<List<dynamic>> getAllInvoices() async {
    try {
      final dynamic data = await BaseApiService.getRequest('Invoices');
      return data as List<dynamic>;
    } catch (e) {
      return []; // في حال حدوث خطأ يُرجع قائمة فارغة كما كنت تفعل
    }
  }
}