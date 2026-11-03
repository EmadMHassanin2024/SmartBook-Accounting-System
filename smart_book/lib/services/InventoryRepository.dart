import '../../../../core/network/base_api_service.dart';
import '../features/inventory/data/models/inventory_transaction.dart';
import '../features/pos/data/models/product_model.dart';
import '../models/ ProductUnitModel.dart';


class InventoryRepository {

  // 1. إضافة صنف جديد
  Future<bool> addProduct({
    required String name,
    required String barcode,
    required double totalStockQuantity,
   String? itemType,
    required List<ProductUnitModel> productUnits,
    String? expiryDate,
    String? batchNumber,
    bool isIngredient = false,
    String? size,
    String? color,
  }) async {
    final Map<String, dynamic> body = {
      "ProductNameAr": name,
      "Barcode": barcode.isEmpty ? null : barcode,
      "TotalStockQuantity": totalStockQuantity,
      "ItemType": itemType,
      "IsIngredient": isIngredient,
      "ExpiryDate": expiryDate,
      "BatchNumber": batchNumber,
      "Size": size,
      "Color": color,
      "ProductUnits": productUnits.map((unit) => unit.toJson()).toList(),
    };

    try {
      await BaseApiService.postRequest('Products/AddProduct', body);
      return true;
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  // 2. تعديل صنف
  Future<bool> updateProduct({
    required int id,
    required String name,
    required String barcode,
    required double totalStockQuantity,
     String ?itemType,
    required List<ProductUnitModel> productUnits,
    String? expiryDate,
    String? batchNumber,
    bool isIngredient = false,
    String? size,
    String? color,
  }) async {
    final Map<String, dynamic> body = {
      "ProductId": id,
      "ProductNameAr": name,
      "Barcode": barcode.isEmpty ? null : barcode,
      "TotalStockQuantity": totalStockQuantity,
      "ItemType": itemType,
      "IsIngredient": isIngredient,
      "ExpiryDate": expiryDate,
      "BatchNumber": batchNumber,
      "Size": size,
      "Color": color,
      "ProductUnits": productUnits.map((unit) => unit.toJson()).toList(),
    };

    try {
      await BaseApiService.putRequest('Products/$id', body);
      return true;
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  // 3. جلب جميع المنتجات
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final dynamic data = await BaseApiService.getRequest('Products');

      if (data is List) {
        return data.map((item) => ProductModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  // 4. حفظ حركة المخزن
  Future<bool> saveAdjustment(InventoryTransaction transaction) async {
    try {
      await BaseApiService.postRequest(
        'Products/adjust-stock',
        transaction.toJson(),
      );
      return true;
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  // 5. حذف صنف
  Future<void> deleteProduct(int productId) async {
    try {
      await BaseApiService.deleteRequest('Products/$productId');
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}