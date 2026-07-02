class InvoiceItemModel {
  final String productId; // ID كـ String
  final String productName;
  final double unitPrice;
  int quantity;
  final double vatRate;

  InvoiceItemModel({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    this.quantity = 1,
    this.vatRate = 0.15,
  });

  // حسابات منطقية (Logic)
  double get subTotal => unitPrice * quantity;
  double get vatAmount => subTotal * vatRate;
  double get total => subTotal + vatAmount;

  // 💡 دالة تحويل البيانات من السيرفر إلى الكلاس (لحل مشكلة fromMap)
  factory InvoiceItemModel.fromMap(Map<String, dynamic> map) {
    return InvoiceItemModel(
      // تحويل الـ int القادم من السيرفر إلى String ليتوافق مع الـ Model
      productId: map['productId']?.toString() ?? '0',
      productName: map['productName'] ?? 'غير معروف',
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      quantity: (map['quantity'] ?? 1).toInt(),
      vatRate: (map['vatRate'] ?? 0.15).toDouble(),
    );
  }

  // 💡 دالة تحويل البيانات للكلاس لإرسالها للـ API
  Map<String, dynamic> toJson() {
    return {
      // إرسال الـ productId كرقم صريح (int) كما يتوقع السيرفر
      'productId': int.tryParse(productId) ?? 0,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'vatAmount': vatAmount,
    };
  }
}