import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/packages.dart';

import '../../system_config/data/models/ business_module.dart';
import '../../system_config/data/models/system_settings_model.dart';

import '../../system_config/logic/system_configuration_cubit.dart';
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
  final SystemConfigurationCubit _systemConfigurationCubit;
  final PosRepository _posService;

  BusinessExtension? get activeExtension => _currentExtension;

  final List<CartItemModel> _currentCart = [];
  List<ProductModel> _allProducts = [];
  String _currentSearchQuery = '';

  PosCubit(this._posService, this._systemConfigurationCubit) : super(PosInitial()) {
    initialize();
  }

  Future<void> initialize() async {
    // 1. التأكد من انتهاء تحميل الإعدادات أولاً
    final configCubit = _systemConfigurationCubit;
    if (configCubit.state.isLoading) {
      await configCubit.stream.firstWhere(
            (state) => !state.isLoading,
      );
    }

    // 2. جلب الإعدادات وتحديد النشاط
    final settings = configCubit.state.settings;
    final extension = _resolveBusinessExtension(settings);

    // 3. إصدار الحالة وجلب المنتجات
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
      _allProducts.where((product) => product.stock >= 0).toList();

  /// حساب الإجمالي النهائي شاملاً الضريبة (15%)
  double get _calculatedFinalTotal {
    final subtotal = _currentCart.fold<double>(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );
    return subtotal * 1.15;
  }

  /// بناء حالة POS الحالية مع ضمان نسخ القائمة والعناصر لتغيير المراجع.
  void _emitLoaded({BusinessExtension? extension}) {
    final total = _currentCart.fold<double>(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );

    // 🎯 الحل الجذري: إنشاء نسخة جديدة من الكائنات والقائمة تماماً لضمان اكتشاف التغيير في الـ UI
    final copiedCartItems = _currentCart.map((item) {
      return CartItemModel(
        product: item.product,
        quantity: item.quantity,
      );
    }).toList();

    // تطبيق فلترة البحث إن وجدت لكي لا تضيع نتيجة البحث عند تحديث السلة
    List<ProductModel> productsToEmit = availableProducts;
    if (_currentSearchQuery.isNotEmpty) {
      final currentExt = extension ?? _currentExtension;
      String activityType = 'general';
      if (currentExt != null) {
        activityType = _resolveActivityType(currentExt);
      }
      productsToEmit = availableProducts.where((product) {
        final matchesExtension =
            activityType == 'general' || product.itemType == activityType;
        final matchesSearch = product.name
            .toLowerCase()
            .contains(_currentSearchQuery.toLowerCase());
        return matchesExtension && matchesSearch;
      }).toList();
    }

    emit(
      PosLoaded(
        cartItems: copiedCartItems,
        products: productsToEmit,
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
    if (product.stock < 0) return;

    final index = _currentCart.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index != -1) {
      // تحديث الكمية بإنشاء عنصر جديد لمنع مشاكل الـ Reference
      final existing = _currentCart[index];
      _currentCart[index] = CartItemModel(
        product: existing.product,
        quantity: existing.quantity + 1,
      );
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
      _allProducts[productIndex] = _allProducts[productIndex].copyWith(
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
      final existing = _currentCart[index];
      _currentCart[index] = CartItemModel(
        product: existing.product,
        quantity: existing.quantity - 1,
      );
    } else {
      _currentCart.removeAt(index);
    }

    final productIndex = _allProducts.indexWhere(
          (item) => item.id == product.id,
    );

    if (productIndex != -1) {
      _allProducts[productIndex] = _allProducts[productIndex].copyWith(
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
      _allProducts[productIndex] = _allProducts[productIndex].copyWith(
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
  bool _isCheckingOut = false;

  /// تنفيذ الدفع مع منع تكرار الطلب من نفس الـ Cubit.
  Future<void> checkoutWithMethod(PaymentMethod method) async {
    if (_isCheckingOut || _currentCart.isEmpty) return;

    _isCheckingOut = true;

    final paymentType = method.name;
    final finalTotal = _calculatedFinalTotal;
    final extension = _currentExtension;

    // نأخذ نسخة من السلة حتى لا تتغير بيانات الفاتورة أثناء التنفيذ.
    final invoiceItems = List<CartItemModel>.from(_currentCart);

    emit(PosSubmitting(extension: extension));

    try {
      // 1. حفظ الفاتورة على السيرفر.
      final success = await _posService.saveInvoice(
        invoiceItems,
        paymentType,
      );

      if (!success) {
        emit(
          PosError(
            'فشل حفظ الفاتورة، يرجى المحاولة مجددًا',
            extension: extension,
          ),
        );

        return;
      }

      // 2. الحفظ نجح: نفرغ السلة فورًا لمنع إعادة إرسال نفس الفاتورة.
      _currentCart.clear();

      // 3. الطباعة عملية منفصلة عن حفظ الفاتورة.
      var printFailed = false;

      try {
        await InvoicePdfHelper.generateAndPrintReceipt(
          invoiceItems,
          finalTotal,
          paymentType,
        );
      } catch (e) {
        printFailed = true;
      }

      // 4. إصدار حالة نجاح الحفظ، مع توضيح فشل الطباعة إن حدث.
      emit(
        PosSuccess(
          extension: extension,
        ),
      );

      // 5. تحديث المخزون بشكل مستقل.
      try {
        await fetchInventoryProducts(extension: extension);
      } catch (e) {
        // فشل تحديث المخزون لا يعني فشل حفظ الفاتورة.
      }
    } catch (e) {
      emit(
        PosError(
          e.toString(),
          extension: extension,
        ),
      );
    } finally {
      _isCheckingOut = false;
    }
  }

  void searchProducts(String query) {
    _currentSearchQuery = query;
    _emitFilteredProducts();
  }

  void _emitFilteredProducts() {
    _emitLoaded(extension: activeExtension);
  }

  /// دالة لاستخراج نوع النشاط من الـ BusinessExtension
  String _resolveActivityType(BusinessExtension extension) {
    if (extension is PharmacyExtension) return 'pharmacy';
    if (extension is RestaurantExtension) return 'restaurant';
    return extension.extensionName.toLowerCase();
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