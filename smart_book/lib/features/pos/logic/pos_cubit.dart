import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/packages.dart';

import '../../system_config/data/models/ business_module.dart';
import '../../system_config/data/models/system_settings_model.dart';

import '../business_extension/pharmacy/pharmacy_extension.dart';
import '../business_extension/restaurant/restaurant_extension.dart';

import '../core/PaymentMethod.dart';
import '../core/business_extension.dart';

import '../../../services/InvoicePdfHelper.dart';
import '../data/Repository/PosRepository.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';

import 'PosState.dart';

class PosCubit extends Cubit<PosState> {
  final PosRepository _posService;

  BusinessExtension? get activeExtension => _currentExtension;

  final List<CartItemModel> _currentCart = [];
  List<ProductModel> _allProducts = [];

  PosCubit(this._posService) : super(PosInitial());

  /// تهيئة نقطة البيع عند فتح الشاشة.
  Future<void> initialize(SystemSettingsModel settings) async {
    final extension = _resolveBusinessExtension(settings);

    emit(
      PosLoadingProducts(
        extension: extension,
      ),
    );

    await fetchInventoryProducts(
      extension: extension,
    );
  }

  /// تحديد النشاط التجاري بناءً على إعدادات النظام.
  BusinessExtension? _resolveBusinessExtension(
      SystemSettingsModel settings,
      ) {
    if (settings.hasBusinessModule(BusinessModule.pharmacy)) {
      return PharmacyExtension();
    }

    if (settings.hasBusinessModule(BusinessModule.restaurant)) {
      return RestaurantExtension();
    }

    return null;
  }

  /// تطبيق إعدادات النشاط التجاري.
  void applySettingsExtension(SystemSettingsModel settings) {
    final extension = _resolveBusinessExtension(settings);

    if (_allProducts.isNotEmpty || _currentCart.isNotEmpty) {
      _emitLoaded(
        extension: extension,
      );
    }
  }

  /// تعيين النشاط التجاري يدوياً عند الحاجة.
  void setBusinessExtension(BusinessExtension extension) {
    _emitLoaded(
      extension: extension,
    );
  }

  /// المنتجات المتاحة للبيع فقط.
  List<ProductModel> get availableProducts =>
      _allProducts.where((product) => product.stock > 0).toList();

  /// حساب الإجمالي النهائي شاملاً الضريبة (15%)
  double get _calculatedFinalTotal {
    final subtotal = _currentCart.fold<double>(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );
    return subtotal * 1.15;
  }

  /// بناء حالة POS الحالية.
  void _emitLoaded({
    BusinessExtension? extension,
  }) {
    final total = _currentCart.fold<double>(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );

    emit(
      PosLoaded(
        cartItems: List.from(_currentCart),
        products: List.from(availableProducts),
        total: total,
        extension: extension,
      ),
    );
  }

  /// جلب منتجات المخزون.
  Future<void> fetchInventoryProducts({
    BusinessExtension? extension,
  }) async {
    emit(
      PosLoadingProducts(
        extension: extension,
      ),
    );

    try {
      _allProducts = await _posService.getAllProducts();

      _emitLoaded(
        extension: extension,
      );
    } catch (e) {
      emit(
        PosError(
          e.toString(),
          extension: extension,
        ),
      );
    }
  }

  /// إضافة منتج إلى السلة.
  void addToCart(ProductModel product) {
    if (product.stock <= 0) return;

    final index = _currentCart.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index != -1) {
      _currentCart[index].quantity++;
    } else {
      _currentCart.add(
        CartItemModel(
          product: product,
          quantity: 1,
        ),
      );
    }

    final productIndex = _allProducts.indexWhere(
          (item) => item.id == product.id,
    );

    if (productIndex != -1) {
      _allProducts[productIndex] =
          _allProducts[productIndex].copyWith(
            stock: _allProducts[productIndex].stock - 1,
          );
    }

    _emitLoaded(
      extension: _currentExtension,
    );
  }

  /// تقليل كمية المنتج في السلة.
  void decreaseCartItem(ProductModel product) {
    final index = _currentCart.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index == -1) return;

    if (_currentCart[index].quantity > 1) {
      _currentCart[index].quantity--;
    } else {
      _currentCart.removeAt(index);
    }

    final productIndex = _allProducts.indexWhere(
          (item) => item.id == product.id,
    );

    if (productIndex != -1) {
      _allProducts[productIndex] =
          _allProducts[productIndex].copyWith(
            stock: _allProducts[productIndex].stock + 1,
          );
    }

    _emitLoaded(
      extension: _currentExtension,
    );
  }

  /// حذف المنتج بالكامل من السلة.
  void removeFromCart(ProductModel product) {
    final index = _currentCart.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index == -1) return;

    final quantityToRemove = _currentCart[index].quantity;

    final productIndex = _allProducts.indexWhere(
          (item) => item.id == product.id,
    );

    if (productIndex != -1) {
      _allProducts[productIndex] =
          _allProducts[productIndex].copyWith(
            stock: _allProducts[productIndex].stock + quantityToRemove,
          );
    }

    _currentCart.removeAt(index);

    _emitLoaded(
      extension: _currentExtension,
    );
  }

  /// النشاط الحالي الموجود داخل الـ State.
  BusinessExtension? get _currentExtension {
    final currentState = state;
    if (currentState is PosLoaded) return currentState.extension;
    if (currentState is PosLoadingProducts) return currentState.extension;
    if (currentState is PosSubmitting) return currentState.extension;
    if (currentState is PosSuccess) return currentState.extension;
    if (currentState is PosError) return currentState.extension;
    return null;
  }

  /// تنفيذ الدفع باستخدام طريقة الدفع المحددة.
  Future<void> checkoutWithMethod(
      PaymentMethod method,
      ) async {
    if (_currentCart.isEmpty) return;

    final paymentType = method.name;
    final finalTotal = _calculatedFinalTotal;
    final extension = _currentExtension;

    emit(
      PosSubmitting(
        extension: extension,
      ),
    );

    try {
      final success = await _posService.saveInvoice(
        _currentCart,
        paymentType,
      );

      if (!success) {
        emit(
          PosError(
            'فشل حفظ الفاتورة',
            extension: extension,
          ),
        );
        return;
      }

      await InvoicePdfHelper.generateAndPrintReceipt(
        _currentCart,
        finalTotal,
        paymentType,
      );

      _currentCart.clear();

      emit(
        PosSuccess(
          extension: extension,
        ),
      );

      await fetchInventoryProducts(
        extension: extension,
      );
    } catch (e) {
      emit(
        PosError(
          e.toString(),
          extension: extension,
        ),
      );
    }
  }

  /// الطريقة القديمة للدفع للتوافق مع الاستخدامات القديمة.
  Future<void> checkout({
    required String paymentType,
    required List<dynamic> invoiceItems,
    required double finalTotal,
  }) async {
    if (_currentCart.isEmpty) return;

    final extension = _currentExtension;

    emit(
      PosSubmitting(
        extension: extension,
      ),
    );

    try {
      final success = await _posService.saveInvoice(
        _currentCart,
        paymentType,
      );

      if (!success) {
        emit(
          PosError(
            'فشل حفظ الفاتورة',
            extension: extension,
          ),
        );
        return;
      }

      await InvoicePdfHelper.generateAndPrintReceipt(
        invoiceItems,
        finalTotal,
        paymentType,
      );

      _currentCart.clear();

      emit(
        PosSuccess(
          extension: extension,
        ),
      );

      await fetchInventoryProducts(
        extension: extension,
      );
    } catch (e) {
      emit(
        PosError(
          e.toString(),
          extension: extension,
        ),
      );
    }
  }

  /// معرفة كمية منتج معين داخل السلة.
  int getQuantityInCart(ProductModel product) {
    final item = _currentCart.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItemModel(
        product: product,
        quantity: 0,
      ),
    );

    return item.quantity;
  }
}