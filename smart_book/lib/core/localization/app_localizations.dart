import 'package:flutter/material.dart';
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


      LanguageKeys.notifyWhenQuantityReachesKey: LanguageAR.notifyWhenQuantityReachesAR,
      LanguageKeys.unitsAndPricesKey: LanguageAR.unitsAndPricesAR,
      LanguageKeys.confirmAndSaveKey: LanguageAR.confirmAndSaveAR,
      LanguageKeys.salePriceKey: LanguageAR.salePriceAR,
      LanguageKeys.purchasePriceKey: LanguageAR.purchasePriceAR,
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

      LanguageKeys.notifyWhenQuantityReachesKey: LanguageEN.notifyWhenQuantityReachesEN,
      LanguageKeys.unitsAndPricesKey: LanguageEN.unitsAndPricesEN,
      LanguageKeys.confirmAndSaveKey: LanguageEN.confirmAndSaveEN,
      LanguageKeys.salePriceKey: LanguageEN.salePriceEN,
      LanguageKeys.purchasePriceKey: LanguageEN.purchasePriceEN,
    }
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

  // الدالة الأساسية للترجمة
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  @override bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);
  @override Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }
  @override bool shouldReload(AppLocalizationsDelegate old) => false;
}

// Extension لتسهيل الاستدعاء مباشرة مثل طريقة context.translate(...)
extension TranslationExtension on BuildContext {
  String translate(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}