import '../../../../core/network/base_api_service.dart';
import '../features/invoices/models/invoice_item_model.dart';
// تم حذف استيراد AuthService لأنه لم يعد مطلوباً هنا

class InvoiceRepository {

  Future<bool> submitInvoice({
    required String customerName,
    required List<InvoiceItemModel> items,
    required double totalAmount,
    required String paymentMethod,
  }) async {

    const endpoint = 'Invoices/save-invoice';

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
      // BaseApiService سيتولى التوكين، وإذا نجح الطلب سيمر بسلام.
      // وإذا حدث خطأ (مثل 400 أو 500)، BaseApiService سيرمي Exception تلقائياً.
      await BaseApiService.postRequest(endpoint, requestBody);

      return true; // طالما لم يحدث استثناء، فالعملية تمت بنجاح

    } catch (e) {
      // التقاط أي خطأ قادم من السيرفر أو الشبكة وتمريره بنظافة
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}