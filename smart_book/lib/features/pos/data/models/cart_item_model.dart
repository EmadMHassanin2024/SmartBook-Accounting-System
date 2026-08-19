
import 'package:smart_book/features/pos/auth_exports.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  // 1. حساب إجمالي السطر الحقيقي (الكمية × سعر الصنف الموحد المستخرج من السيرفر)
  double get subTotal => product.price * quantity;

  // 2. حساب قيمة الضريبة (15%) الخاصة بهذا السطر المحاسبي تلقائياً
  double get vatAmount => subTotal * 0.15;

  // 3. الإجمالي النهائي للسطر الشامل لقيمة الضريبة
  double get totalWithVat => subTotal + vatAmount;

  // 4. تحويل البيانات لـ JSON مطابقة تماماً لما ينتظره الـ DTO في الـ Web API الخاص بك
  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'unitPrice': product.price,
      'vatAmount': vatAmount,
    };
  }
}