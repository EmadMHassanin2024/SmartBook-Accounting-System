// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سمارت بوك';

  @override
  String get appTitle => 'سمارت بوك للمحاسبة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get wallet => 'المحفظة';

  @override
  String get onboardingTitle => 'إدارة أموالك بدقة';

  @override
  String get onboardingDescription =>
      'تتبع فواتيرك ومصروفاتك وتقاريرك المحاسبية بكل سهولة واحترافية.';

  @override
  String get getYourCoffee => 'هات قهوتك';

  @override
  String get andLetsStart => 'وهيا نبدأ';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get or => 'أو';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInSubtitle => 'للمتابعة إلى حسابك';

  @override
  String get logInAsGuest => 'تسجيل الدخول كضيف';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get passwordConfirm => 'تأكيد كلمة المرور';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get fillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get passwordsNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get registrationSuccess => 'تمت العملية بنجاح';

  @override
  String get registrationFailed => 'فشل التسجيل: ';

  @override
  String get keepMeSignedIn => 'البقاء متصلاً';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get continueWithFacebook => 'المتابعة باستخدام Facebook';

  @override
  String get loginError => 'خطأ في تسجيل الدخول، تأكد من البيانات';

  @override
  String get serverError => 'خطأ في الاتصال بالسيرفر';

  @override
  String get posTitle => 'نقطة البيع (POS)';

  @override
  String get cartDetails => 'تفاصيل السلة';

  @override
  String get emptyCart => 'سلة المشتريات فارغة حالياً';

  @override
  String get subTotal => 'المجموع';

  @override
  String get vat => 'الضريبة (15%)';

  @override
  String get total => 'الإجمالي';

  @override
  String get confirmAndPay => 'تأكيد ودفع (F10)';

  @override
  String get delete => 'حذف';

  @override
  String get inventoryTitle => 'الأصناف والمستودع';

  @override
  String get addProduct => 'إضافة صنف جديد';

  @override
  String get allProducts => 'كل الأصناف';

  @override
  String get outOfStock => 'منتهية';

  @override
  String get lowStock => 'قربت تنتهي';

  @override
  String get searchHint => 'بحث باسم الصنف أو الباركود...';

  @override
  String get noProductsMatch => 'لا توجد أصناف تطابق اختيارك';

  @override
  String get barcode => 'باركود';

  @override
  String get noBarcode => 'بدون باركود';

  @override
  String get stockCount => 'المخزون';

  @override
  String get baseUnit => 'الوحدة الأساسية';

  @override
  String get basicInfo => 'المعلومات الأساسية';

  @override
  String get itemName => 'اسم الصنف (أرز، زيت..)';

  @override
  String get enterItemName => 'يرجى إدخال اسم الصنف';

  @override
  String get initialStock => 'الكمية الافتتاحية بـ';

  @override
  String get reorderLevel => 'نبهني عند وصول الكمية إلى:';

  @override
  String get unitSettings => 'وحدات القياس والأسعار';

  @override
  String get addUnit => 'إضافة وحدة بيع أخرى (جملة)';

  @override
  String get unitName => 'اسم الوحدة (قطعة، كرتونة..)';

  @override
  String get salePrice => 'سعر البيع';

  @override
  String get purchasePrice => 'سعر الشراء';

  @override
  String get conversionFactor => 'عامل التحويل (كم قطعة في هذه الوحدة؟)';

  @override
  String get confirmAndSave => 'تأكيد وحفظ الصنف';

  @override
  String get saveSuccess => 'تم حفظ الصنف بنجاح وبدقة محاسبية! ✅';

  @override
  String get pos => 'نقطة البيع';

  @override
  String get journals => 'دفتر اليومية';

  @override
  String stockAlert(Object count) {
    return 'تنبيه: $count صنف قاربت على النفاد';
  }

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get quickSummary => 'ملخص مالي سريع';

  @override
  String get quickActions => 'العمليات السريعة';

  @override
  String get salesToday => 'مبيعات اليوم';

  @override
  String get paymentVouchers => 'سندات صرف';

  @override
  String get smartAnalytics => 'التحليلات الذكية';

  @override
  String get viewCharts => 'شاهد الرسوم البيانية وأداء مبيعاتك';

  @override
  String get ledger => 'دفتر الأستاذ';

  @override
  String get receiptVoucher => 'سند قبض';

  @override
  String get paymentVoucher => 'سند صرف';

  @override
  String get trialBalance => 'ميزان المراجعة';

  @override
  String get chartOfAccounts => 'دليل الحسابات';

  @override
  String get invoices => 'الفواتير';

  @override
  String get inventory => 'المخزون';

  @override
  String get contacts => 'جهات الاتصال';

  @override
  String get ledgerTitle => 'دفتر الأستاذ';

  @override
  String get finalBalanceLabel => 'الرصيد الختامي:';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get debitLabel => 'مدين';

  @override
  String get creditLabel => 'دائن';

  @override
  String get balanceLabel => 'الرصيد';

  @override
  String get reportDate => 'تاريخ التقرير';

  @override
  String get changeDate => 'تغيير التاريخ';

  @override
  String get code => 'الكود';

  @override
  String get account => 'الحساب';

  @override
  String get totalDebit => 'إجمالي مدين';

  @override
  String get totalCredit => 'إجمالي دائن';

  @override
  String get balanceDebit => 'رصيد مدين';

  @override
  String get balanceCredit => 'رصيد دائن';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get description => 'البيان';

  @override
  String get adjustments => 'قيود التسويات';

  @override
  String get adjustmentType => 'نوع التسوية';

  @override
  String get amount => 'المبلغ';

  @override
  String get totalAmount => 'إجمالي التسويات';

  @override
  String get accrued => 'مستحقة';

  @override
  String get prepaid => 'مقدمة';

  @override
  String get depreciation => 'إهلاك';

  @override
  String get incomeStatement => 'قائمة الدخل';

  @override
  String get noDataFound => 'لا توجد بيانات للفترة المحددة';

  @override
  String get noContraAccount => 'لا يوجد طرف مقابل';
}
