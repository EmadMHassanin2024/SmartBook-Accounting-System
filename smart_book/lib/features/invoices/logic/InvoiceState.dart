// 1. تعريف حالة الفاتورة (Invoice State) - Smart Book
import '../models/invoice_item_model.dart';

class InvoiceState {
  final List<InvoiceItemModel> items;
  final double subTotal;
  final double totalVat;
  final double finalTotal;
  final bool isLoading;
  final String paymentMethod; // "نقدي" أو "شبكة / مدى"

  InvoiceState({
    required this.items,
    this.subTotal = 0,
    this.totalVat = 0,
    this.finalTotal = 0,
    this.isLoading = false,
    this.paymentMethod = "نقدي", // القيمة الافتراضية الذكية للكاشير
  });

  // 💡 تعديل البارامتر ليكون اختيارياً ويقبل الـ null ليعمل الـ دمج بسلاسة
  InvoiceState copyWith({
    List<InvoiceItemModel>? items,
    double? subTotal,
    double? totalVat,
    double? finalTotal,
    bool? isLoading,
    String? paymentMethod,
  }) {
    return InvoiceState(
      items: items ?? this.items,
      subTotal: subTotal ?? this.subTotal,
      totalVat: totalVat ?? this.totalVat,
      finalTotal: finalTotal ?? this.finalTotal,
      isLoading: isLoading ?? this.isLoading,
      paymentMethod: paymentMethod ?? this.paymentMethod, // الحفاظ على القيمة السابقة إذا لم تتغير
    );
  }
}

//TODO
//QR Code للفاتورة الضريبية