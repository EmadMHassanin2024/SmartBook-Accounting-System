import 'package:smart_book/features/inventory/auth_exports.dart';


abstract class InventoryState extends Equatable {
  const InventoryState();
  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryError extends InventoryState {
  final String message;
  const InventoryError(this.message);
  @override
  List<Object?> get props => [message];
}

class InventoryLoaded extends InventoryState {
  final List<ProductModel> products;
  final List<ProductModel> allProducts;
  final List<ProductModel> lowStockItems;
  final List<ProductModel> outOfStockItems; // تم تعريفه هنا
  final int totalCount;
  final int lowStockCount;
  final int outOfStockCount;
  final double totalInventoryValue;

  const InventoryLoaded({
    required this.products,
    required this.allProducts,
    required this.lowStockItems,
    required this.outOfStockItems, // مضاف للـ Constructor
    required this.totalCount,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.totalInventoryValue,
  });

  InventoryLoaded copyWith({
    List<ProductModel>? products,
    List<ProductModel>? allProducts,
    List<ProductModel>? lowStockItems,
    List<ProductModel>? outOfStockItems, // مضاف للـ copyWith
    int? totalCount,
    int? lowStockCount,
    int? outOfStockCount,
    double? totalInventoryValue,
  }) {
    return InventoryLoaded(
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      lowStockItems: lowStockItems ?? this.lowStockItems,
      outOfStockItems: outOfStockItems ?? this.outOfStockItems, // مضاف للـ return
      totalCount: totalCount ?? this.totalCount,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      outOfStockCount: outOfStockCount ?? this.outOfStockCount,
      totalInventoryValue: totalInventoryValue ?? this.totalInventoryValue,
    );
  }

  @override
  List<Object?> get props => [
    products,
    allProducts,
    lowStockItems,
    outOfStockItems, // مضاف للـ props
    totalCount,
    lowStockCount,
    outOfStockCount,
    totalInventoryValue
  ];
}