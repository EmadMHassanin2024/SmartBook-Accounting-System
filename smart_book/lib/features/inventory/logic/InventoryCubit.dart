import 'package:smart_book/features/inventory/auth_exports.dart';

import '../../../services/ProductRepository.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final ProductRepository _productService;

  // المتغيرات المخزنة محلياً للحالة
  List<ProductModel> _allProducts = [];
  String _currentCategory = "الكل";
  String _currentQuery = "";

  // تم حذف allProducts و lowStockItems من Constructor
  // لأن الـ Cubit يجب أن يجلبها بنفسه أو يحتفظ بها محلياً
  InventoryCubit(this._productService) : super(InventoryInitial());

  // 1. حساب القيمة المالية
  double _calculateTotalInventoryValue(List<ProductModel> products) {
    return products.fold(0.0, (sum, item) => sum + (item.stock * item.purchasePrice));
  }

  // 2. دالة بناء الحالة (State) - تم إضافة lowStockItems هنا للربط مع الشاشة
  InventoryLoaded _buildLoadedState(List<ProductModel> filteredList) {
    final lowStock = _allProducts.where((p) => p.stock > 0 && p.stock <= 10).toList();
    final outOfStock = _allProducts.where((p) => p.stock <= 0).toList();

    return InventoryLoaded(
      products: filteredList, // القائمة المعروضة حالياً
      allProducts: _allProducts, // جميع المنتجات
      lowStockItems: lowStock, // القائمة التي ستظهر في التنبيه
      totalCount: _allProducts.length,
      lowStockCount: lowStock.length,
      outOfStockItems: outOfStock,
      outOfStockCount: _allProducts.where((p) => p.stock <= 0).length,
      totalInventoryValue: _calculateTotalInventoryValue(_allProducts),
    );
  }

  // 3. الفلترة المركزية
  void _applyFilters() {
    List<ProductModel> results = _allProducts;

    if (_currentCategory == "منتهية") {
      results = results.where((p) => p.stock <= 0).toList();
    } else if (_currentCategory == "قربت تنتهي") {
      results = results.where((p) => p.stock > 0 && p.stock <= 10).toList();
    }

    if (_currentQuery.isNotEmpty) {
      final searchLabel = _currentQuery.toLowerCase();
      results = results.where((product) {
        final name = (product.name ?? "").toLowerCase();
        final barcode = (product.barcode ?? "").toLowerCase();
        return name.contains(searchLabel) || barcode.contains(searchLabel);
      }).toList();
    }

    emit(_buildLoadedState(results));
  }

  // 4. جلب البيانات (تم إصلاح الخطأ البرمجي هنا)
  Future<void> fetchProducts() async {
    emit(InventoryLoading());
    try {
      _allProducts = await _productService.fetchProducts();
      // تطبيق الفلترة فوراً بعد الجلب
      _applyFilters();
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  // 5. البحث
  void filterProducts(String query) {
    _currentQuery = query;
    _applyFilters();
  }

  // 6. التصنيف
  void filterByCategory(String category) {
    _currentCategory = category;
    _applyFilters();
  }
}