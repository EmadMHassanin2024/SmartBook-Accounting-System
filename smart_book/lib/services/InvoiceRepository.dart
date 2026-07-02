// lib/features/invoices/data/repositories/invoice_repository.dart
import '../../../../core/network/base_api_service.dart';
import '../features/invoices/models/invoice_item_model.dart';
import 'AuthService.dart';

class InvoiceRepository {

  Future<bool> submitInvoice({
    required String customerName,
    required List<InvoiceItemModel> items,
    required double totalAmount,
    required String paymentMethod,
  }) async {

    // 💡 جلب التوكين داخلياً من خدمة AuthService
    final String token = await AuthService.getToken();

    if (token.isEmpty) {
      // يمكنك هنا إطلاق Custom Exception إذا أردت معالجة أفضل للخطأ
      print("❌ خطأ: لم يتم العثور على توكن للمستخدم.");
      return false;
    }

    final endpoint = 'Invoices/save-invoice';

    final Map<String, dynamic> requestBody = {
      "customerName": customerName.isEmpty ? "عميل نقدي" : customerName,
      "totalAmount": totalAmount,
      "paymentMethod": paymentMethod,
      "invoiceItems": items.map((item) => {
        "productId": item.productId,
        "quantity": item.quantity,
        "unitPrice": item.unitPrice,
        "vatAmount": item.vatAmount,
      }).toList(),
    };

    try {
      final response = await BaseApiService.postRequest(endpoint, requestBody, token);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("❌ Server Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Network Error: $e");
      return false;
    }
  }
}