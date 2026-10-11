import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/settings/logic/SettingsCubit.dart';
import 'language_keys.dart';
import 'language_ar.dart';
import 'language_en.dart';

class AppLanguages {
  static Map<String, Map<String, String>> translations = {
    'ar': {
      LanguageKeys.appNameKey: LanguageAR.appNameAR,
      LanguageKeys.appTitleKey: LanguageAR.appTitleAR,
      LanguageKeys.loginKey: LanguageAR.loginAR,
      LanguageKeys.signUpKey: LanguageAR.signUpAR,
      LanguageKeys.addProductKey: LanguageAR.addProductAR,
      LanguageKeys.basicInfoKey: LanguageAR.basicInfoAR,
      LanguageKeys.productNameKey: LanguageAR.productNameAR,
      LanguageKeys.barcodeKey: LanguageAR.barcodeAR,
      LanguageKeys.initialStockKey: LanguageAR.initialStockAR,
      LanguageKeys.pleaseEnterItemNameKey: LanguageAR.pleaseEnterItemNameAR,
      LanguageKeys.pleaseEnterValidQuantityKey: LanguageAR.pleaseEnterValidQuantityAR,
      LanguageKeys.pleaseEnterInitialStockKey: LanguageAR.pleaseEnterInitialStockAR,
      LanguageKeys.addAnotherUnitKey: LanguageAR.addAnotherUnitAR,
      LanguageKeys.salePriceKey: LanguageAR.salePriceAR,
      LanguageKeys.purchasePriceKey: LanguageAR.purchasePriceAR,
      LanguageKeys.unitsAndPricesKey: LanguageAR.unitsAndPricesAR,
      LanguageKeys.confirmAndSaveKey: LanguageAR.confirmAndSaveAR,
      LanguageKeys.notifyWhenQuantityReachesKey: LanguageAR.notifyWhenQuantityReachesAR,
      LanguageKeys.allCategoryKey: LanguageAR.allAR,
      LanguageKeys.expiredCategoryKey: LanguageAR.expiredAR,
      LanguageKeys.lowStockCategoryKey: LanguageAR.lowStockAR,
      LanguageKeys.saveSuccessKey: LanguageAR.saveSuccessAR,
      LanguageKeys.activity: LanguageAR.activityAR,
      LanguageKeys.pointOfSaleGeneral: LanguageAR.pointOfSaleGeneralAR,
      LanguageKeys.systemSettings: LanguageAR.systemSettingsAR,
      LanguageKeys.paymentSuccessMessage: LanguageAR.paymentSuccessMessage,
      LanguageKeys.searchProductHint: LanguageAR.searchProductHint,
      LanguageKeys.noProductsFound: LanguageAR.noProductsFound,
      LanguageKeys.emptyCartMessage: LanguageAR.emptyCartMessage,
      LanguageKeys.newInvoice: LanguageAR.newInvoice,
      LanguageKeys.emptyCart: LanguageAR.emptyCart,
      LanguageKeys.decreaseQuantity: LanguageAR.decreaseQuantity,
      LanguageKeys.increaseQuantity: LanguageAR.increaseQuantity,
      LanguageKeys.deleteProductTooltip: LanguageAR.deleteProductTooltip,
      LanguageKeys.delete: LanguageAR.delete,
      LanguageKeys.confirmDeleteTitle: LanguageAR.confirmDeleteTitle,
      LanguageKeys.confirmDeleteMessage: LanguageAR.confirmDeleteMessage,
      LanguageKeys.cancel: LanguageAR.cancel,
      LanguageKeys.loadingMessage: LanguageAR.loadingMessage,
      LanguageKeys.submittingMessage: LanguageAR.submittingMessage,
      LanguageKeys.choosePaymentMethod: LanguageAR.choosePaymentMethod,
      LanguageKeys.requiredTotal: LanguageAR.requiredTotal,
      LanguageKeys.cashMethod: LanguageAR.cashMethod,
      LanguageKeys.cardMethod: LanguageAR.cardMethod,
      LanguageKeys.creditMethod: LanguageAR.creditMethod,
      LanguageKeys.addImage: LanguageAR.addImage,
      LanguageKeys.remainingStock: LanguageAR.remainingStock,
      LanguageKeys.add: LanguageAR.add,
      LanguageKeys.subTotal: LanguageAR.subTotal,
      LanguageKeys.vatTax: LanguageAR.vatTax,
      LanguageKeys.finalTotal: LanguageAR.finalTotal,
      LanguageKeys.confirmAndPay: LanguageAR.confirmAndPay,
      LanguageKeys.salesAnalytics: LanguageAR.salesAnalytics,
      LanguageKeys.monthlySalesGrowth: LanguageAR.monthlySalesGrowth,
      LanguageKeys.topProducts: LanguageAR.topProducts,
      LanguageKeys.topCustomers: LanguageAR.topCustomers,
      LanguageKeys.activeActivity: LanguageAR.activeActivity,
      LanguageKeys.retry: LanguageAR.retry,
      LanguageKeys.reportPreparing: LanguageAR.reportPreparing,
      LanguageKeys.noDataToExport: LanguageAR.noDataToExport,
      LanguageKeys.printOrExportReport: LanguageAR.printOrExportReport,
      LanguageKeys.activeModule: LanguageAR.activeModule,
      LanguageKeys.refreshData: LanguageAR.refreshData,
      LanguageKeys.totalSales: LanguageAR.totalSales,
      LanguageKeys.vat15: LanguageAR.vat15,
      LanguageKeys.netProfit: LanguageAR.netProfit,
      LanguageKeys.totalInvoices: LanguageAR.totalInvoices,
      LanguageKeys.smartAnalytics: LanguageAR.smartAnalytics,
      LanguageKeys.viewCharts: LanguageAR.viewCharts,
      LanguageKeys.salesToday: LanguageAR.salesToday,
      LanguageKeys.paymentVouchers: LanguageAR.paymentVouchers,
      LanguageKeys.editProductKey: LanguageAR.editProductAR,
    },
    'en': {
      LanguageKeys.appNameKey: LanguageEN.appNameEN,
      LanguageKeys.appTitleKey: LanguageEN.appTitleEN,
      LanguageKeys.loginKey: LanguageEN.loginEN,
      LanguageKeys.signUpKey: LanguageEN.signUpEN,
      LanguageKeys.addProductKey: LanguageEN.addProductEN,
      LanguageKeys.basicInfoKey: LanguageEN.basicInfoEN,
      LanguageKeys.productNameKey: LanguageEN.productNameEN,
      LanguageKeys.barcodeKey: LanguageEN.barcodeEN,
      LanguageKeys.initialStockKey: LanguageEN.initialStockEN,
      LanguageKeys.pleaseEnterItemNameKey: LanguageEN.pleaseEnterItemNameEN,
      LanguageKeys.pleaseEnterValidQuantityKey: LanguageEN.pleaseEnterValidQuantityEN,
      LanguageKeys.pleaseEnterInitialStockKey: LanguageEN.pleaseEnterInitialStockEN,
      LanguageKeys.addAnotherUnitKey: LanguageEN.addAnotherUnitEN,
      LanguageKeys.salePriceKey: LanguageEN.salePriceEN,
      LanguageKeys.purchasePriceKey: LanguageEN.purchasePriceEN,
      LanguageKeys.unitsAndPricesKey: LanguageEN.unitsAndPricesEN,
      LanguageKeys.confirmAndSaveKey: LanguageEN.confirmAndSaveEN,
      LanguageKeys.notifyWhenQuantityReachesKey: LanguageEN.notifyWhenQuantityReachesEN,
      LanguageKeys.allCategoryKey: LanguageEN.allEN,
      LanguageKeys.expiredCategoryKey: LanguageEN.expiredEN,
      LanguageKeys.lowStockCategoryKey: LanguageEN.lowStockEN,
      LanguageKeys.saveSuccessKey: LanguageEN.saveSuccessEN,
      LanguageKeys.activity: LanguageEN.activityEN,
      LanguageKeys.pointOfSaleGeneral: LanguageEN.pointOfSaleGeneralEN,
      LanguageKeys.systemSettings: LanguageEN.systemSettingsEN,
      LanguageKeys.paymentSuccessMessage: LanguageEN.paymentSuccessMessage,
      LanguageKeys.searchProductHint: LanguageEN.searchProductHint,
      LanguageKeys.noProductsFound: LanguageEN.noProductsFound,
      LanguageKeys.emptyCartMessage: LanguageEN.emptyCartMessage,
      LanguageKeys.newInvoice: LanguageEN.newInvoice,
      LanguageKeys.emptyCart: LanguageEN.emptyCart,
      LanguageKeys.decreaseQuantity: LanguageEN.decreaseQuantity,
      LanguageKeys.increaseQuantity: LanguageEN.increaseQuantity,
      LanguageKeys.deleteProductTooltip: LanguageEN.deleteProductTooltip,
      LanguageKeys.delete: LanguageEN.delete,
      LanguageKeys.confirmDeleteTitle: LanguageEN.confirmDeleteTitle,
      LanguageKeys.confirmDeleteMessage: LanguageEN.confirmDeleteMessage,
      LanguageKeys.cancel: LanguageEN.cancel,
      LanguageKeys.loadingMessage: LanguageEN.loadingMessage,
      LanguageKeys.submittingMessage: LanguageEN.submittingMessage,
      LanguageKeys.choosePaymentMethod: LanguageEN.choosePaymentMethod,
      LanguageKeys.requiredTotal: LanguageEN.requiredTotal,
      LanguageKeys.cashMethod: LanguageEN.cashMethod,
      LanguageKeys.cardMethod: LanguageEN.cardMethod,
      LanguageKeys.creditMethod: LanguageEN.creditMethod,
      LanguageKeys.addImage: LanguageEN.addImage,
      LanguageKeys.remainingStock: LanguageEN.remainingStock,
      LanguageKeys.add: LanguageEN.add,
      LanguageKeys.subTotal: LanguageEN.subTotal,
      LanguageKeys.vatTax: LanguageEN.vatTax,
      LanguageKeys.finalTotal: LanguageEN.finalTotal,
      LanguageKeys.confirmAndPay: LanguageEN.confirmAndPay,
      LanguageKeys.salesAnalytics: LanguageEN.salesAnalytics,
      LanguageKeys.monthlySalesGrowth: LanguageEN.monthlySalesGrowth,
      LanguageKeys.topProducts: LanguageEN.topProducts,
      LanguageKeys.topCustomers: LanguageEN.topCustomers,
      LanguageKeys.activeActivity: LanguageEN.activeActivity,
      LanguageKeys.retry: LanguageEN.retry,
      LanguageKeys.reportPreparing: LanguageEN.reportPreparing,
      LanguageKeys.noDataToExport: LanguageEN.noDataToExport,
      LanguageKeys.printOrExportReport: LanguageEN.printOrExportReport,
      LanguageKeys.activeModule: LanguageEN.activeModule,
      LanguageKeys.refreshData: LanguageEN.refreshData,
      LanguageKeys.totalSales: LanguageEN.totalSales,
      LanguageKeys.vat15: LanguageEN.vat15,
      LanguageKeys.netProfit: LanguageEN.netProfit,
      LanguageKeys.totalInvoices: LanguageEN.totalInvoices,
      LanguageKeys.smartAnalytics: LanguageEN.smartAnalytics,
      LanguageKeys.viewCharts: LanguageEN.viewCharts,
      LanguageKeys.salesToday: LanguageEN.salesToday,
      LanguageKeys.paymentVouchers: LanguageEN.paymentVouchers,
      LanguageKeys.editProductKey: LanguageEN.editProductEN,
    },
  };
}

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();
  static const Iterable<Locale> supportedLocales = [Locale('ar'), Locale('en')];

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    _localizedStrings = AppLanguages.translations[locale.languageCode] ?? AppLanguages.translations['ar']!;
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

extension TranslationExtension on BuildContext {
  String translate(String key) {
    // 1. محاولة الجلب عبر الـ Localizations الرسمية
    final localizations = AppLocalizations.of(this);
    if (localizations != null) {
      return localizations.translate(key);
    }

    // 2. الجلب المباشر من SettingsCubit لضمان دعم العربية والإنجليزية بلا توقف
    try {
      final currentLocale = read<SettingsCubit>().state;
      final langCode = AppLanguages.translations.containsKey(currentLocale.languageCode)
          ? currentLocale.languageCode
          : 'ar';
      return AppLanguages.translations[langCode]?[key] ?? key;
    } catch (_) {
      return AppLanguages.translations['ar']?[key] ?? key;
    }
  }
}