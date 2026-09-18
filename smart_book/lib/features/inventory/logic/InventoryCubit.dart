import 'package:smart_book/features/inventory/auth_exports.dart';
import 'dart:async';

import '../../../core/localization/language_keys.dart';

class InventoryCubit extends Cubit<InventoryState> {
  static const int lowStockThreshold = 10;
  final ProductRepository _productService;
  final SystemConfigurationCubit _systemConfigurationCubit;
  late final StreamSubscription _systemConfigSubscription;

  List<ProductModel> _allProducts = [];
  String _currentCategory =  LanguageKeys.allCategoryKey;
  String _currentQuery = "";
  late BusinessModule _currentActivityType;

  InventoryCubit(this._productService, this._systemConfigurationCubit)
      : super(InventoryInitial()) {
    _currentActivityType =
        _systemConfigurationCubit.state.settings.activeBusinessModule;

    _systemConfigSubscription = _systemConfigurationCubit.stream.listen((state) {
      final newModule = state.settings.activeBusinessModule;
      if (_currentActivityType != newModule) {
        changeActivityType(newModule);
      }
    });
  }

  Future<void> initialize() async {
    if (_systemConfigurationCubit.state.isLoading) {
      await _systemConfigurationCubit.stream.firstWhere(
            (state) => !state.isLoading,
      );
    }

    final activeModule =
        _systemConfigurationCubit.state.settings.activeBusinessModule;

    _currentActivityType = activeModule;

    await fetchProducts();
  }

  Future<void> fetchProducts({String? businessModule}) async {
    emit(InventoryLoading());
    try {
      _allProducts = await _productService.fetchProducts();
      _applyFilters();
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }
  double _calculateTotalInventoryValue(List<ProductModel> products) {
    return products.fold(
        0.0, (sum, item) => sum + ((item.stock) * (item.purchasePrice)));
  }

  InventoryLoaded _buildLoadedState(
      List<ProductModel> filteredList, List<ProductModel> activityProducts) {
    final lowStock = activityProducts
        .where((p) => p.stock > 0 && p.stock <= lowStockThreshold)
        .toList();
    final outOfStock = activityProducts.where((p) => p.stock <= 0).toList();

    return InventoryLoaded(
      products: filteredList,
      allProducts: _allProducts,
      lowStockItems: lowStock,
      totalCount: activityProducts.length,
      lowStockCount: lowStock.length,
      outOfStockItems: outOfStock,
      outOfStockCount: outOfStock.length,
      totalInventoryValue: _calculateTotalInventoryValue(activityProducts),
    );
  }


  void _applyFilters() {
    print("🔍 [InventoryCubit] تطبيق الفلاتر على عدد منتجات خام: ${_allProducts.length}");

    // 1. فلترة المنتجات بناءً على النشاط الحالي
    List<ProductModel> activityProducts = _allProducts.where((p) {
      final productType = (p.itemType ?? "").trim().toLowerCase();
      final currentType = _currentActivityType.name.trim().toLowerCase();

      bool isMatch = productType == currentType;
      if (!isMatch && (productType == 'general' && _currentActivityType == BusinessModule.generalStore)) {
        isMatch = true;
      }
      return isMatch;
    }).toList();

    // نأخذ نسخة للعمل عليها حتى لا نلعب بالأساسية
    List<ProductModel> results = List.from(activityProducts);

    // 2. فلترة حسب الفئة (منتهية أو قربت تنتهي)
// 2. فلترة حسب الفئة (منتهية أو قربت تنتهي)
    if (_currentCategory == LanguageKeys.expiredCategoryKey) {
      results = results.where((p) => p.stock <= 0).toList();
    } else if (_currentCategory == LanguageKeys.lowStockCategoryKey) {
      results = results
          .where((p) => p.stock > 0 && p.stock <= lowStockThreshold)
          .toList();
    }

    // 3. فلترة حسب نص البحث (الاسم أو الباركود)
    if (_currentQuery.isNotEmpty) {
      final searchLabel = _currentQuery.trim().toLowerCase();
      results = results.where((product) {
        final name = (product.name ?? "").toLowerCase();
        final barcode = (product.barcode ?? "").toLowerCase();
        return name.contains(searchLabel) || barcode.contains(searchLabel);
      }).toList();
    }

    print("🎯 إجمالي المنتجات بعد الفلترة والبحث: ${results.length}");

    // إصدار الحالة الجديدة لتحديث واجهة المستخدم
    emit(_buildLoadedState(results, activityProducts));
  }

  // تأكد أن دوال الفلترة والبحث تستدعي _applyFilters بشكل صحيح
  void filterProducts(String query) {
    _currentQuery = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    _currentCategory = category;
    _applyFilters();
  }



  void changeActivityType(BusinessModule activityType) {
    _currentActivityType = activityType;
    _currentCategory = "الكل";
    _currentQuery = "";
    _applyFilters();
  }

  Future<void> deleteProduct(int productId) async {
    try {
      await _productService.deleteProduct(productId);
      _allProducts.removeWhere((p) => p.id == productId);
      _applyFilters();
    } catch (e) {
      // إرسال خطأ مؤقت أو عام حسب تصميم تطبيقك
      emit(InventoryError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _systemConfigSubscription.cancel();
    return super.close();
  }
}