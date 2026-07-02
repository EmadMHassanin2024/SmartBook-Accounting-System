
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/finance/adjustments/logic/adjustment_cubit.dart';
import '../../features/finance/income_statement/data/repositories/income_statement_repository.dart';
import '../../features/finance/journals/repositories/JournalRepository.dart';
import '../../features/finance/repositories/FinancialReportsRepository.dart';
import '../../features/inventory/data/inventory_repository.dart';



import '../../services/PosRepository.dart';
import '../../services/ProductRepository.dart';

import '../../features/inventory/logic/InventoryCubit.dart';
import '../../features/inventory/logic/add_product_cubit.dart';
import '../repositories/token_repository.dart';

// 💡 إنشاء كائن جلب الخدمات العالمي (sl تعني Service Locator)
final sl = GetIt.instance;

Future<void> setupLocator() async {
  // 1. تسجيل الـ Repositories (يجب أن تُسجل أولاً لأن الـ Cubits تعتمد عليها)
  sl.registerLazySingleton<TokenRepository>(() => TokenRepository());
  sl.registerLazySingleton<JournalRepository>(() => JournalRepository());
  sl.registerLazySingleton<FinancialReportsRepository >(() => FinancialReportsRepository ());
  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepository(http.Client()));
  sl.registerLazySingleton<IncomeStatementRepository>(() => IncomeStatementRepository());
  // 2. تسجيل الـ Services
  sl.registerLazySingleton<ProductRepository>(() => ProductRepository());
  sl.registerLazySingleton<PosRepository>(() => PosRepository());

  // 3. تسجيل الـ Cubits
  // نستخدم registerFactory للـ Cubits لضمان الحصول على نسخة جديدة عند فتح الشاشة
  sl.registerFactory<InventoryCubit>(() => InventoryCubit(sl<ProductRepository>()));

  sl.registerFactory<AddProductCubit>(() => AddProductCubit(sl<ProductRepository>()));
  sl.registerFactory<AdjustmentCubit>(() => AdjustmentCubit(sl<FinancialReportsRepository>()));


}