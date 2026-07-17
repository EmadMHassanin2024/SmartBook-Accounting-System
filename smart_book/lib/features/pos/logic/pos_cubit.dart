import 'package:smart_book/features/pos/auth_exports.dart';

import '../../../services/PosRepository.dart';

class PosCubit extends Cubit<PosState> {
  final  PosRepository _posService;
  final List<CartItemModel> _currentCart = [];
  List<ProductModel> _allProducts = [];

  PosCubit(this._posService) : super(PosInitial());

  // 🎯 Getter للمنتجات المتاحة
  List<ProductModel> get availableProducts =>
      _allProducts.where((p) => p.stock > 0).toList();

  void _emitLoaded() {
    
    emit(PosLoaded(
      cartItems: List.from(_currentCart),
      products: List.from(availableProducts),
      total: _currentCart.fold(0, (sum, item) => sum + (item.product.price * item.quantity)),
    ));
  }

  Future<void> fetchInventoryProducts() async {
    emit(PosLoadingProducts());
    try {
      _allProducts = await _posService.getAllProducts();
      _emitLoaded();
    } catch (e) {
      emit(PosError(e.toString()));
    }
  }

  void addToCart(ProductModel product) {
    if (product.stock <= 0) return;

    // 1. تحديث أو إضافة المنتج للسلة
    final index = _currentCart.indexWhere((i) => i.product.id == product.id);
    if (index != -1) {
      _currentCart[index].quantity++;
    } else {
      _currentCart.add(CartItemModel(product: product, quantity: 1));
    }

    // 2. تحديث المخزون في _allProducts باستخدام copyWith (النهج الصحيح)
    final productIndex = _allProducts.indexWhere((p) => p.id == product.id);
    if (productIndex != -1) {
      _allProducts[productIndex] = _allProducts[productIndex].copyWith(
        stock: _allProducts[productIndex].stock - 1,
      );
    }

    _emitLoaded();
  }

  void decreaseCartItem(ProductModel product) {
    final index = _currentCart.indexWhere((i) => i.product.id == product.id);
    if (index == -1) return;

    // تحديث السلة والمخزون
    if (_currentCart[index].quantity > 1) {
      _currentCart[index].quantity--;
    } else {
      _currentCart.removeAt(index);
    }

    final productIndex = _allProducts.indexWhere((p) => p.id == product.id);
    if (productIndex != -1) {
      _allProducts[productIndex] = _allProducts[productIndex].copyWith(
        stock: _allProducts[productIndex].stock + 1,
      );
    }

    _emitLoaded();
  }

  void removeFromCart(ProductModel product) {
    final index = _currentCart.indexWhere((i) => i.product.id == product.id);
    if (index != -1) {
      final quantityToRemove = _currentCart[index].quantity;

      // إعادة الكمية للمخزون
      final productIndex = _allProducts.indexWhere((p) => p.id == product.id);
      if (productIndex != -1) {
        _allProducts[productIndex] = _allProducts[productIndex].copyWith(
          stock: _allProducts[productIndex].stock + quantityToRemove,
        );
      }

      _currentCart.removeAt(index);
      _emitLoaded();
    }
  }

  Future<void> checkout({
    required String paymentType,
    required List<dynamic> invoiceItems,
    required double finalTotal,
  }) async {
    if (_currentCart.isEmpty) return;

    emit(PosSubmitting());
    try {
      final success = await _posService.saveInvoice(_currentCart, paymentType);

      if (success) {
        await InvoicePdfHelper.generateAndPrintReceipt(invoiceItems, finalTotal, paymentType);
        _currentCart.clear();
        emit(PosSuccess());
        await fetchInventoryProducts(); // إعادة جلب المخزون الفعلي من السيرفر
      } else {
        emit(PosError("فشل حفظ الفاتورة"));
      }
    } catch (e) {
      emit(PosError(e.toString()));
    }
  }


  int getQuantityInCart(ProductModel product) {
    final item = _currentCart.firstWhere(
          (i) => i.product.id == product.id,
      orElse: () => CartItemModel(product: product, quantity: 0),
    );
    return item.quantity;
  }
}