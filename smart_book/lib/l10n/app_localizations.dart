import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'سمارت بوك'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'سمارت بوك للمحاسبة'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get signUp;

  /// No description provided for @wallet.
  ///
  /// In ar, this message translates to:
  /// **'المحفظة'**
  String get wallet;

  /// No description provided for @onboardingTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة أموالك بدقة'**
  String get onboardingTitle;

  /// No description provided for @onboardingDescription.
  ///
  /// In ar, this message translates to:
  /// **'تتبع فواتيرك ومصروفاتك وتقاريرك المحاسبية بكل سهولة واحترافية.'**
  String get onboardingDescription;

  /// No description provided for @getYourCoffee.
  ///
  /// In ar, this message translates to:
  /// **'هات قهوتك'**
  String get getYourCoffee;

  /// No description provided for @andLetsStart.
  ///
  /// In ar, this message translates to:
  /// **'وهيا نبدأ'**
  String get andLetsStart;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get createAccount;

  /// No description provided for @or.
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get or;

  /// No description provided for @signIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get signIn;

  /// No description provided for @signInSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'للمتابعة إلى حسابك'**
  String get signInSubtitle;

  /// No description provided for @logInAsGuest.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول كضيف'**
  String get logInAsGuest;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @passwordConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get passwordConfirm;

  /// No description provided for @username.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم'**
  String get username;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @fillAllFields.
  ///
  /// In ar, this message translates to:
  /// **'يرجى ملء جميع الحقول'**
  String get fillAllFields;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل؟ '**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟ '**
  String get dontHaveAccount;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمات المرور غير متطابقة'**
  String get passwordsNotMatch;

  /// No description provided for @registrationSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تمت العملية بنجاح'**
  String get registrationSuccess;

  /// No description provided for @registrationFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل التسجيل: '**
  String get registrationFailed;

  /// No description provided for @keepMeSignedIn.
  ///
  /// In ar, this message translates to:
  /// **'البقاء متصلاً'**
  String get keepMeSignedIn;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @continueWithGoogle.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة باستخدام Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة باستخدام Facebook'**
  String get continueWithFacebook;

  /// No description provided for @loginError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تسجيل الدخول، تأكد من البيانات'**
  String get loginError;

  /// No description provided for @serverError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في الاتصال بالسيرفر'**
  String get serverError;

  /// No description provided for @posTitle.
  ///
  /// In ar, this message translates to:
  /// **'نقطة البيع (POS)'**
  String get posTitle;

  /// No description provided for @cartDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل السلة'**
  String get cartDetails;

  /// No description provided for @emptyCart.
  ///
  /// In ar, this message translates to:
  /// **'سلة المشتريات فارغة حالياً'**
  String get emptyCart;

  /// No description provided for @subTotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get subTotal;

  /// No description provided for @vat.
  ///
  /// In ar, this message translates to:
  /// **'الضريبة (15%)'**
  String get vat;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get total;

  /// No description provided for @confirmAndPay.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد ودفع (F10)'**
  String get confirmAndPay;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @inventoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'الأصناف والمستودع'**
  String get inventoryTitle;

  /// No description provided for @addProduct.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صنف جديد'**
  String get addProduct;

  /// No description provided for @allProducts.
  ///
  /// In ar, this message translates to:
  /// **'كل الأصناف'**
  String get allProducts;

  /// No description provided for @outOfStock.
  ///
  /// In ar, this message translates to:
  /// **'منتهية'**
  String get outOfStock;

  /// No description provided for @lowStock.
  ///
  /// In ar, this message translates to:
  /// **'قربت تنتهي'**
  String get lowStock;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث باسم الصنف أو الباركود...'**
  String get searchHint;

  /// No description provided for @noProductsMatch.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أصناف تطابق اختيارك'**
  String get noProductsMatch;

  /// No description provided for @barcode.
  ///
  /// In ar, this message translates to:
  /// **'باركود'**
  String get barcode;

  /// No description provided for @noBarcode.
  ///
  /// In ar, this message translates to:
  /// **'بدون باركود'**
  String get noBarcode;

  /// No description provided for @stockCount.
  ///
  /// In ar, this message translates to:
  /// **'المخزون'**
  String get stockCount;

  /// No description provided for @baseUnit.
  ///
  /// In ar, this message translates to:
  /// **'الوحدة الأساسية'**
  String get baseUnit;

  /// No description provided for @basicInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الأساسية'**
  String get basicInfo;

  /// No description provided for @itemName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الصنف (أرز، زيت..)'**
  String get itemName;

  /// No description provided for @enterItemName.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال اسم الصنف'**
  String get enterItemName;

  /// No description provided for @initialStock.
  ///
  /// In ar, this message translates to:
  /// **'الكمية الافتتاحية بـ'**
  String get initialStock;

  /// No description provided for @reorderLevel.
  ///
  /// In ar, this message translates to:
  /// **'نبهني عند وصول الكمية إلى:'**
  String get reorderLevel;

  /// No description provided for @unitSettings.
  ///
  /// In ar, this message translates to:
  /// **'وحدات القياس والأسعار'**
  String get unitSettings;

  /// No description provided for @addUnit.
  ///
  /// In ar, this message translates to:
  /// **'إضافة وحدة بيع أخرى (جملة)'**
  String get addUnit;

  /// No description provided for @unitName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الوحدة (قطعة، كرتونة..)'**
  String get unitName;

  /// No description provided for @salePrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر البيع'**
  String get salePrice;

  /// No description provided for @purchasePrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر الشراء'**
  String get purchasePrice;

  /// No description provided for @conversionFactor.
  ///
  /// In ar, this message translates to:
  /// **'عامل التحويل (كم قطعة في هذه الوحدة؟)'**
  String get conversionFactor;

  /// No description provided for @confirmAndSave.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد وحفظ الصنف'**
  String get confirmAndSave;

  /// No description provided for @saveSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الصنف بنجاح وبدقة محاسبية! ✅'**
  String get saveSuccess;

  /// No description provided for @pos.
  ///
  /// In ar, this message translates to:
  /// **'نقطة البيع'**
  String get pos;

  /// No description provided for @journals.
  ///
  /// In ar, this message translates to:
  /// **'دفتر اليومية'**
  String get journals;

  /// No description provided for @stockAlert.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه: {count} صنف قاربت على النفاد'**
  String stockAlert(Object count);

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAll;

  /// No description provided for @quickSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص مالي سريع'**
  String get quickSummary;

  /// No description provided for @quickActions.
  ///
  /// In ar, this message translates to:
  /// **'العمليات السريعة'**
  String get quickActions;

  /// No description provided for @salesToday.
  ///
  /// In ar, this message translates to:
  /// **'مبيعات اليوم'**
  String get salesToday;

  /// No description provided for @paymentVouchers.
  ///
  /// In ar, this message translates to:
  /// **'سندات صرف'**
  String get paymentVouchers;

  /// No description provided for @smartAnalytics.
  ///
  /// In ar, this message translates to:
  /// **'التحليلات الذكية'**
  String get smartAnalytics;

  /// No description provided for @viewCharts.
  ///
  /// In ar, this message translates to:
  /// **'شاهد الرسوم البيانية وأداء مبيعاتك'**
  String get viewCharts;

  /// No description provided for @ledger.
  ///
  /// In ar, this message translates to:
  /// **'دفتر الأستاذ'**
  String get ledger;

  /// No description provided for @receiptVoucher.
  ///
  /// In ar, this message translates to:
  /// **'سند قبض'**
  String get receiptVoucher;

  /// No description provided for @paymentVoucher.
  ///
  /// In ar, this message translates to:
  /// **'سند صرف'**
  String get paymentVoucher;

  /// No description provided for @trialBalance.
  ///
  /// In ar, this message translates to:
  /// **'ميزان المراجعة'**
  String get trialBalance;

  /// No description provided for @chartOfAccounts.
  ///
  /// In ar, this message translates to:
  /// **'دليل الحسابات'**
  String get chartOfAccounts;

  /// No description provided for @invoices.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير'**
  String get invoices;

  /// No description provided for @inventory.
  ///
  /// In ar, this message translates to:
  /// **'المخزون'**
  String get inventory;

  /// No description provided for @contacts.
  ///
  /// In ar, this message translates to:
  /// **'جهات الاتصال'**
  String get contacts;

  /// No description provided for @ledgerTitle.
  ///
  /// In ar, this message translates to:
  /// **'دفتر الأستاذ'**
  String get ledgerTitle;

  /// No description provided for @finalBalanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الختامي:'**
  String get finalBalanceLabel;

  /// No description provided for @dateLabel.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get dateLabel;

  /// No description provided for @debitLabel.
  ///
  /// In ar, this message translates to:
  /// **'مدين'**
  String get debitLabel;

  /// No description provided for @creditLabel.
  ///
  /// In ar, this message translates to:
  /// **'دائن'**
  String get creditLabel;

  /// No description provided for @balanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد'**
  String get balanceLabel;

  /// No description provided for @reportDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ التقرير'**
  String get reportDate;

  /// No description provided for @changeDate.
  ///
  /// In ar, this message translates to:
  /// **'تغيير التاريخ'**
  String get changeDate;

  /// No description provided for @code.
  ///
  /// In ar, this message translates to:
  /// **'الكود'**
  String get code;

  /// No description provided for @account.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get account;

  /// No description provided for @totalDebit.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي مدين'**
  String get totalDebit;

  /// No description provided for @totalCredit.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي دائن'**
  String get totalCredit;

  /// No description provided for @balanceDebit.
  ///
  /// In ar, this message translates to:
  /// **'رصيد مدين'**
  String get balanceDebit;

  /// No description provided for @balanceCredit.
  ///
  /// In ar, this message translates to:
  /// **'رصيد دائن'**
  String get balanceCredit;

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noData;

  /// No description provided for @description.
  ///
  /// In ar, this message translates to:
  /// **'البيان'**
  String get description;

  /// No description provided for @adjustments.
  ///
  /// In ar, this message translates to:
  /// **'قيود التسويات'**
  String get adjustments;

  /// No description provided for @adjustmentType.
  ///
  /// In ar, this message translates to:
  /// **'نوع التسوية'**
  String get adjustmentType;

  /// No description provided for @amount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get amount;

  /// No description provided for @totalAmount.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي التسويات'**
  String get totalAmount;

  /// No description provided for @accrued.
  ///
  /// In ar, this message translates to:
  /// **'مستحقة'**
  String get accrued;

  /// No description provided for @prepaid.
  ///
  /// In ar, this message translates to:
  /// **'مقدمة'**
  String get prepaid;

  /// No description provided for @depreciation.
  ///
  /// In ar, this message translates to:
  /// **'إهلاك'**
  String get depreciation;

  /// No description provided for @incomeStatement.
  ///
  /// In ar, this message translates to:
  /// **'قائمة الدخل'**
  String get incomeStatement;

  /// No description provided for @noDataFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات للفترة المحددة'**
  String get noDataFound;

  /// No description provided for @noContraAccount.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد طرف مقابل'**
  String get noContraAccount;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
