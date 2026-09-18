import 'package:equatable/equatable.dart';

import '../core/business_extension.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';

abstract class PosState extends Equatable {
  const PosState();

  @override
  List<Object?> get props => [];
}

// 2. الحالة الابتدائية
class PosInitial extends PosState {}

// 3. حالة جاري تحميل المنتجات
class PosLoadingProducts extends PosState {
  final BusinessExtension? extension;
  const PosLoadingProducts({this.extension});

  @override
  List<Object?> get props => [extension];
}

// 4. حالة المنتجات محملة والسلة جاهزة
class PosLoaded extends PosState {
  final List<CartItemModel> cartItems;
  final List<ProductModel> products;
  final double total;
  final BusinessExtension? extension;

  const PosLoaded({
    required this.cartItems,
    required this.products,
    required this.total,
    this.extension,
  });

  // 🎯 حسابات مركزية (Single Source of Truth)
  double get subTotal => cartItems.fold(0.0, (sum, item) => sum + item.subTotal);
  double get vatAmount => subTotal * 0.15;
  double get totalAmount => subTotal + vatAmount;

  @override
  List<Object?> get props => [cartItems, products, total, extension];
}

// 5. حالة إرسال الفاتورة
class PosSubmitting extends PosState {
  final BusinessExtension? extension;
  const PosSubmitting({this.extension});

  @override
  List<Object?> get props => [extension];
}

// 6. حالة النجاح
class PosSuccess extends PosState {
  final BusinessExtension? extension;
  const PosSuccess({this.extension});

  @override
  List<Object?> get props => [extension];
}

// 7. حالة الخطأ
class PosError extends PosState {
  final String message;
  final BusinessExtension? extension;

  const PosError(this.message, {this.extension});

  @override
  List<Object?> get props => [message, extension];
}