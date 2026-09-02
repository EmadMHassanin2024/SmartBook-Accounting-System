import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryCubit extends Cubit<InventoryState> {
  static const int lowStockThreshold = 10;
  final ProductRepository _productService;

  List<ProductModel> _allProducts = [];
  String _currentCategory = "الكل";
  String _currentQuery = "";
  BusinessModule _currentActivityType = BusinessModule.generalStore;

  InventoryCubit(this._productService) : super(InventoryInitial());

  double _calculateTotalInventoryValue(List<ProductModel> products) {
    return products.fold(0.0, (sum, item) => sum + (item.stock * item.purchasePrice));
  }

  InventoryLoaded _buildLoadedState(List<ProductModel> filteredList, List<ProductModel> activityProducts) {
    final lowStock = activityProducts.where((p) => p.stock > 0 && p.stock <= lowStockThreshold).toList();
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
    // 1. تصفية منتجات النشاط الحالي أولاً


    List<ProductModel> activityProducts = _allProducts.where((p) {
      return (p.itemType ?? BusinessModule.generalStore.name) == _currentActivityType.name;
    }).toList();

    List<ProductModel> results = List.from(activityProducts);

    // 2. تصفية حسب حالة المخزون
    if (_currentCategory == "منتهية") {
      results = results.where((p) => p.stock <= 0).toList();
    } else if (_currentCategory == "قربت تنتهي") {
      results = results.where((p) => p.stock > 0 && p.stock <= lowStockThreshold).toList();
    }

    // 3. تصفية حسب البحث (الاسم أو الباركود)
    if (_currentQuery.isNotEmpty) {
      final searchLabel = _currentQuery.toLowerCase();
      results = results.where((product) {
        final name = (product.name ?? "").toLowerCase();
        final barcode = (product.barcode ?? "").toLowerCase();
        return name.contains(searchLabel) || barcode.contains(searchLabel);
      }).toList();
    }

    // 4. إرسال الحالة مع تمرير القائمة المفلترة والقائمة الأساسية للنشاط
    emit(_buildLoadedState(results, activityProducts));
  }

  Future<void> fetchProducts() async {
    emit(InventoryLoading());
    try {
      _allProducts = await _productService.fetchProducts();
      _applyFilters();
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

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
}