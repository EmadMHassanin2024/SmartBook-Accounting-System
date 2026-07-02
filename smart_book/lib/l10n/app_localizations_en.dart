// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Smart Book';

  @override
  String get appTitle => 'Smart Book Accounting';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get wallet => 'Wallet';

  @override
  String get onboardingTitle => 'Manage Your Finances';

  @override
  String get onboardingDescription =>
      'Track your invoices, expenses, and accounting reports easily and professionally.';

  @override
  String get getYourCoffee => 'Get Your Coffee';

  @override
  String get andLetsStart => 'And Let\'s Start';

  @override
  String get createAccount => 'Create account';

  @override
  String get or => 'OR';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInSubtitle => 'to continue to your account';

  @override
  String get logInAsGuest => 'Log In As Guest';

  @override
  String get fullName => 'Full Name';

  @override
  String get passwordConfirm => 'Confirm Password';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String get registrationSuccess => 'Process completed successfully';

  @override
  String get registrationFailed => 'Registration failed: ';

  @override
  String get keepMeSignedIn => 'Keep me signed in';

  @override
  String get forgotPassword => 'FORGOT PASSWORD?';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get loginError => 'Login failed, please check your credentials';

  @override
  String get serverError => 'Server connection error';

  @override
  String get posTitle => 'Point of Sale (POS)';

  @override
  String get cartDetails => 'Cart Details';

  @override
  String get emptyCart => 'Cart is currently empty';

  @override
  String get subTotal => 'Subtotal';

  @override
  String get vat => 'VAT (15%)';

  @override
  String get total => 'Total';

  @override
  String get confirmAndPay => 'Confirm & Pay (F10)';

  @override
  String get delete => 'Delete';

  @override
  String get inventoryTitle => 'Items & Inventory';

  @override
  String get addProduct => 'Add New Item';

  @override
  String get allProducts => 'All Items';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get lowStock => 'Low Stock';

  @override
  String get searchHint => 'Search by item name or barcode...';

  @override
  String get noProductsMatch => 'No items match your selection';

  @override
  String get barcode => 'Barcode (Optional)';

  @override
  String get noBarcode => 'No Barcode';

  @override
  String get stockCount => 'Stock';

  @override
  String get baseUnit => 'Base Unit';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get itemName => 'Item Name (e.g., Rice, Oil...)';

  @override
  String get enterItemName => 'Please enter item name';

  @override
  String get initialStock => 'Opening Stock in';

  @override
  String get reorderLevel => 'Alert at quantity:';

  @override
  String get unitSettings => 'Units & Prices';

  @override
  String get addUnit => 'Add Another Selling Unit (Wholesale)';

  @override
  String get unitName => 'Unit Name (e.g., Piece, Carton...)';

  @override
  String get salePrice => 'Sale Price';

  @override
  String get purchasePrice => 'Purchase Price';

  @override
  String get conversionFactor => 'Conversion Factor (Items per unit?)';

  @override
  String get confirmAndSave => 'Confirm & Save Item';

  @override
  String get saveSuccess =>
      'Item saved successfully with accounting precision! ✅';

  @override
  String get pos => 'POS';

  @override
  String get journals => 'Journals';

  @override
  String stockAlert(Object count) {
    return 'Alert: $count items running low';
  }

  @override
  String get viewAll => 'View All';

  @override
  String get quickSummary => 'Quick Financial Summary';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get salesToday => 'Today\'s Sales';

  @override
  String get paymentVouchers => 'Payment Vouchers';

  @override
  String get smartAnalytics => 'Smart Analytics';

  @override
  String get viewCharts => 'View charts and your sales performance';

  @override
  String get ledger => 'Ledger';

  @override
  String get receiptVoucher => 'Receipt Voucher';

  @override
  String get paymentVoucher => 'Payment Voucher';

  @override
  String get trialBalance => 'Trial Balance';

  @override
  String get chartOfAccounts => 'Chart of Accounts';

  @override
  String get invoices => 'Invoices';

  @override
  String get inventory => 'Inventory';

  @override
  String get contacts => 'Contacts';

  @override
  String get ledgerTitle => 'General Ledger';

  @override
  String get finalBalanceLabel => 'Final Balance:';

  @override
  String get dateLabel => 'Date';

  @override
  String get debitLabel => 'Debit';

  @override
  String get creditLabel => 'Credit';

  @override
  String get balanceLabel => 'Balance';

  @override
  String get reportDate => 'Report Date';

  @override
  String get changeDate => 'Change Date';

  @override
  String get code => 'Code';

  @override
  String get account => 'Account';

  @override
  String get totalDebit => 'Total Debit';

  @override
  String get totalCredit => 'Total Credit';

  @override
  String get balanceDebit => 'Balance Debit';

  @override
  String get balanceCredit => 'Balance Credit';

  @override
  String get noData => 'No Data Found';

  @override
  String get description => 'Description';

  @override
  String get adjustments => 'Adjustments';

  @override
  String get adjustmentType => 'Adjustment Type';

  @override
  String get amount => 'Amount';

  @override
  String get totalAmount => 'Total Adjustments';

  @override
  String get accrued => 'Accrued';

  @override
  String get prepaid => 'Prepaid';

  @override
  String get depreciation => 'Depreciation';

  @override
  String get incomeStatement => 'Income Statement';

  @override
  String get noDataFound => 'No data found for the selected period';

  @override
  String get noContraAccount => 'No Contra Account';
}
