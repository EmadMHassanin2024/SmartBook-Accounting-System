import 'package:smart_book/features/auth/auth_exports.dart' hide AppLocalizations;
import 'package:smart_book/features/inventory/auth_exports.dart';

import 'package:smart_book/features/pos/logic/pos_cubit.dart';
import 'package:smart_book/features/finance/journals/repositories/JournalRepository.dart';
import 'package:smart_book/features/finance/journals/logic/JournalListCubit.dart';
import 'package:smart_book/features/finance/ledger/logic/ledger_cubit.dart';

import 'package:smart_book/features/finance/TrialBalance/logic/TrialBalanceCubit.dart';
import 'package:smart_book/features/finance/Account/logic/account_cubit.dart';

import 'core/routes/AppRouter.dart';
import 'core/routes/app_routes.dart';
import 'core/widgets/main_layout.dart';

import 'features/finance/income_statement/data/repositories/income_statement_repository.dart';
import 'features/finance/income_statement/logic/income_statement_cubit.dart';
import 'features/finance/repositories/FinancialReportsRepository.dart';

import 'features/pos/data/Repository/PosRepository.dart';
import 'features/settings/logic/SettingsCubit.dart';


import 'core/localization/app_localizations.dart'; // تأكد من استيراد ملف الترجمة الصحيح

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }

  await setupLocator();
  runApp(const SmartBookApp());
}

class SmartBookApp extends StatelessWidget {
  const SmartBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SystemConfigurationCubit>(
          create: (context) => sl<SystemConfigurationCubit>()..loadConfiguration(),
        ),
        BlocProvider<InventoryCubit>(create: (_) => sl<InventoryCubit>()),

        // تم تصحيح AddProductCubit بإزالة الـ child الخاطئ
        BlocProvider<AddProductCubit>(create: (_) => sl<AddProductCubit>()),

        BlocProvider<SettingsCubit>(create: (_) => SettingsCubit()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit(sl<TokenRepository>())),
        BlocProvider<IncomeStatementCubit>(
          create: (context) => IncomeStatementCubit(sl<IncomeStatementRepository>()),
        ),
        BlocProvider<TrialBalanceCubit>(create: (_) => TrialBalanceCubit(sl<FinancialReportsRepository>())),
        BlocProvider<AccountCubit>(create: (_) => AccountCubit(sl<FinancialReportsRepository>())),
        BlocProvider<JournalListCubit>(create: (_) => JournalListCubit(sl<JournalRepository>())),
        BlocProvider<LedgerCubit>(create: (_) => LedgerCubit(sl<FinancialReportsRepository>())),
        BlocProvider<AdjustmentCubit>(create: (context) => AdjustmentCubit(sl<FinancialReportsRepository>())),
        BlocProvider<PosCubit>(create: (context) => PosCubit(sl<PosRepository>())),
      ],
      child: BlocBuilder<SettingsCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SmartBook',
            initialRoute: AppRoutes.login,
            onGenerateRoute: AppRouter.generateRoute,
            locale: locale,

            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              primaryColor: AppColors.primaryBlue,
              scaffoldBackgroundColor: AppColors.ghostWhite,
              fontFamily: 'Cairo',
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.cardBg,
                elevation: 0.5,
                iconTheme: IconThemeData(color: AppColors.primaryBlue),
              ),
            ),
            routes: {
              '/': (context) => const LoginScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/main': (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}