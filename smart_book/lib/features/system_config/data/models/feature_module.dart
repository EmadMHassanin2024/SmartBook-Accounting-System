//نموذج يمثل الميزات الإضافية (مثل ماسح الباركود).
enum FeatureModule {

  //-------------------
  // Sales
  //-------------------

  barcodeScanner,

  barcodePrinting,

  weightScale,

  //-------------------
  // Pharmacy
  //-------------------

  batchTracking,

  expiryManagement,

  prescription,

  medicineAlternatives,

  dosageInstructions,

  controlledDrugs,

  insuranceSupport,

  //-------------------
  // Restaurant
  //-------------------

  tableManagement,

  kitchenDisplay,

  deliveryManagement,

  takeAway,

  splitBill,

  //-------------------
  // Company
  //-------------------

  multiWarehouse,

  multiBranch,

  multiCurrency,

  taxManagement,

  //-------------------
  // Marketing
  //-------------------

  loyaltyPoints,

  giftCards,

  //-------------------
  // System

  offlineMode,
}