import 'package:equatable/equatable.dart';
import 'package:smart_book/features/pos/auth_exports.dart';


abstract class PosState extends Equatable {
  const PosState();

  @override
  List<Object?> get props => [];
}

class PosInitial extends PosState {}

class PosLoadingProducts extends PosState {}

class PosLoaded extends PosState {
  final List<CartItemModel> cartItems;
  final List<ProductModel> products;
  final double total;

  const PosLoaded({
    required this.cartItems,
    required this.products, required this.total
  });

  // 🎯 حسابات مركزية (Single Source of Truth)
  double get subTotal => cartItems.fold(0.0, (sum, item) => sum + item.subTotal);
  double get vatAmount => subTotal * 0.15;
  double get totalAmount => subTotal + vatAmount;

  @override
  List<Object?> get props => [cartItems, products]; // Equatable يقارن هذه القيم فقط
}

class PosSubmitting extends PosState {}

class PosSuccess extends PosState {}

class PosError extends PosState {
  final String message;
  const PosError(this.message);

  @override
  List<Object?> get props => [message];
}