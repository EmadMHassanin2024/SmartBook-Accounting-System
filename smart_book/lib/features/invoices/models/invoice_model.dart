import 'invoice_item_model.dart';

class InvoiceModel {
  final String id; // أضفت ID لاستخدامه في وصف القيد
  final String invoiceNumber;
  final String customerName;
  final double totalAmount; // الإجمالي شامل الضريبة
  final double subTotal;    // الإجمالي قبل الضريبة
  final double tax;         // قيمة الضريبة
  final String date;
  final String status;
  final List<InvoiceItemModel> items;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.customerName,
    required this.totalAmount,
    required this.subTotal,
    required this.tax,
    required this.date,
    required this.status,
    required this.items,
  });

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id']?.toString() ?? '',
      invoiceNumber: map['number'] ?? '',
      customerName: map['customer'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      subTotal: (map['subTotal'] ?? 0.0).toDouble(),
      tax: (map['tax'] ?? 0.0).toDouble(),
      date: map['date'] ?? '',
      status: map['status'] ?? '',
      // تحويل مصفوفة الأصناف إذا كانت موجودة
      items: map['items'] != null
          ? List<InvoiceItemModel>.from(map['items']?.map((x) => InvoiceItemModel.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceDate': date,
      'totalAmount': totalAmount,
      'subTotal': subTotal,
      'tax': tax,
      'paymentType': 'Cash',
      'description': 'فاتورة للعميل: $customerName',
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}