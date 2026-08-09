import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/product_model.dart';
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
  final List<CartItemModel> _currentCart = [];
  List<ProductModel> _allProducts = [];

  // النشاط التجاري النشط حالياً في الـ POS
  BusinessExtension? activeExtension;

  PosCubit(this._posService) : super(PosInitial());

  /// 🎯 التحديد التلقائي للنشاط بناءً على إعدادات النظام المحفوظة
  void applySettingsExtension(SystemSettingsModel settings) {
    if (settings.hasBusinessModule(BusinessModule.pharmacy)) {
      activeExtension = PharmacyExtension();
    } else if (settings.hasBusinessModule(BusinessModule.restaurant)) {
      activeExtension = RestaurantExtension();
    } else {
      activeExtension = null; // متجر عام أو افتراضي بدون إضافات خاصة
    }

    // إذا كانت المنتجات محمّلة مسبقاً، نعيد تحديث الحالة لينعكس النشاط على الواجهة
    if (_allProducts.isNotEmpty || _currentCart.isNotEmpty) {
      _emitLoaded();
    } else {
      emit(PosExtensionChanged(activeExtension));
    }
  }

  // 🎯 تعيين النشاط التجاري يدوياً إذا لزم الأمر
  void setBusinessExtension(BusinessExtension extension) {
    activeExtension = extension;
    _emitLoaded();
  }

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

    final index = _currentCart.indexWhere((i) => i.product.id == product.id);
    if (index != -1) {
      _currentCart[index].quantity++;
    } else {
      _currentCart.add(CartItemModel(product: product, quantity: 1));
    }

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

  /// 🎯 دالة الدفع الحديثة باستخدام PaymentMethod المنبثقة
  Future<void> checkoutWithMethod(PaymentMethod method) async {
    if (_currentCart.isEmpty) return;

    // تحويل الـ Enum إلى نص لكي يتم إرساله للـ Repository وخدمات الطباعة
    final String paymentTypeStr = method.name; // أو تحويله إلى نص عربي مثل "نقدي" أو "شبكة" حسب الرغبة

    // حساب الإجمالي النهائي شاملاً الضريبة أو كما هو مخزن

    final double finalTotal = _currentCart.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity)) * 1.15;

    emit(PosSubmitting());
    try {
      final success = await _posService.saveInvoice(_currentCart, paymentTypeStr);

      if (success) {
        await InvoicePdfHelper.generateAndPrintReceipt(_currentCart, finalTotal, paymentTypeStr);
        _currentCart.clear();
        emit(PosSuccess());
        await fetchInventoryProducts();
      } else {
        emit(PosError("فشل حفظ الفاتورة"));
      }
    } catch (e) {
      emit(PosError(e.toString()));
    }
  }

  /// الدالة القديمة للتوافقية (إن كانت مستخدمة في أماكن أخرى)
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
        await fetchInventoryProducts();
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