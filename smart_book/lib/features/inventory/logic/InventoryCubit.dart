import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryCubit extends Cubit<InventoryState> {
  static const int lowStockThreshold = 10;

  // الحقن الذاتي للـ Repository باستخدام GetIt (sl)
  final InventoryRepository _productService = sl<InventoryRepository>();

  List<ProductModel> _allProducts = [];
  String _currentCategory = LanguageKeys.allCategoryKey;
  String _currentQuery = "";

  InventoryCubit() : super(InventoryInitial());

  Future<void> initialize() async {
    // التحقق الذكي من الـ Cache
    if (_allProducts.isNotEmpty) {
      _applyFilters();
    } else {
      await fetchProducts();
    }
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

  /// 💡 دالة مساعدة لتوحيد الحروف العربية وتجاوز مشاكل الهمزات والتاء المربوطة
  String _normalizeArabic(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[أإآا]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }

  void _applyFilters() {
    List<ProductModel> activityProducts = List.from(_allProducts);
    List<ProductModel> results = List.from(_allProducts);

    // 1. فلترة حسب الفئة
    if (_currentCategory == LanguageKeys.expiredCategoryKey) {
      results = results.where((p) => p.stock <= 0).toList();
    } else if (_currentCategory == LanguageKeys.lowStockCategoryKey) {
      results = results
          .where((p) => p.stock > 0 && p.stock <= lowStockThreshold)
          .toList();
    }

    // 2. فلترة حسب نص البحث (مع تطبيق معالجة الهمزات العربية والباركود)
    if (_currentQuery.isNotEmpty) {
      final searchLabel = _normalizeArabic(_currentQuery.trim());
      results = results.where((product) {
        final name = _normalizeArabic(product.name ?? "");
        final barcode = (product.barcode ?? "").toLowerCase();

        return name.contains(searchLabel) || barcode.contains(searchLabel);
      }).toList();
    }

    // إصدار الحالة الجديدة لتحديث واجهة المستخدم
    emit(_buildLoadedState(results, activityProducts));
  }

  void filterProducts(String query) {
    _currentQuery = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    _currentCategory = category;
    _applyFilters();
  }

  void changeActivityType(dynamic activityType) {
    _currentCategory = LanguageKeys.allCategoryKey;
    _currentQuery = "";
    _applyFilters();
  }

  Future<void> deleteProduct(int productId) async {
    try {
      await _productService.deleteProduct(productId);
      _allProducts.removeWhere((p) => p.id == productId);
      _applyFilters();
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}