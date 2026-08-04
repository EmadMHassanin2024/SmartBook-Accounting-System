import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/finance/adjustments/logic/adjustment_cubit.dart';
import '../../features/finance/income_statement/data/repositories/income_statement_repository.dart';
import '../../features/finance/journals/repositories/JournalRepository.dart';
import '../../features/finance/repositories/FinancialReportsRepository.dart';

import '../../features/inventory/data/inventory_repository.dart';
import '../../features/inventory/logic/InventoryCubit.dart';
import '../../features/inventory/logic/add_product_cubit.dart';

import '../../features/pos/data/Repository/PosRepository.dart';

// ⚠️ احتفظ باستيراد واحد فقط موحد وصحيح (حسب اسم الملف الفعلي في جهازك)
import '../../features/system_config/data/repositories/SystemConfigurationRepository.dart';
import '../../features/system_config/data/repositories/system_configuration_repository.dart';
import '../../features/system_config/logic/system_configuration_cubit.dart';
import '../../services/ProductRepository.dart';

import '../repositories/token_repository.dart';

/// Service Locator
final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  //------------------------------------------------------------
  // Repositories
  //------------------------------------------------------------

  sl.registerLazySingleton<TokenRepository>(
        () => TokenRepository(),
  );

  sl.registerLazySingleton<JournalRepository>(
        () => JournalRepository(),
  );

  sl.registerLazySingleton<FinancialReportsRepository>(
        () => FinancialReportsRepository(),
  );

  sl.registerLazySingleton<InventoryRepository>(
        () => InventoryRepository(
      http.Client(),
    ),
  );

  sl.registerLazySingleton<IncomeStatementRepository>(
        () => IncomeStatementRepository(),
  );

  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepository(),
  );

  sl.registerLazySingleton<PosRepository>(
        () => PosRepository(),
  );

  //------------------------------------------------------------
  // ⭐ System Configuration Repository
  //------------------------------------------------------------

  sl.registerLazySingleton<SystemConfigurationRepository>(
        () => SystemConfigurationRepositoryImpl(),
  );

  //------------------------------------------------------------
  // Cubits
  //------------------------------------------------------------

  sl.registerFactory<InventoryCubit>(
        () => InventoryCubit(
      sl<ProductRepository>(),
    ),
  );

  sl.registerFactory<AddProductCubit>(
        () => AddProductCubit(
      sl<ProductRepository>(),
    ),
  );

  sl.registerFactory<AdjustmentCubit>(
        () => AdjustmentCubit(
      sl<FinancialReportsRepository>(),
    ),
  );

  sl.registerFactory<SystemConfigurationCubit>(
        () => SystemConfigurationCubit(
      sl<SystemConfigurationRepository>(),
    ),
  );
}