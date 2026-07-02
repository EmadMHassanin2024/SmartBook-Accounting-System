enum VoucherType { receipt, payment } // قبض أو صرف

class VoucherModel {
  final String id;
  final String voucherNumber;
  final DateTime date;
  final double amount;
  final String accountId;      // الحساب المتأثر (العميل/المورد)
  final String treasuryId;     // حساب الصندوق أو البنك
  final String note;           // البيان/الملاحظات
  final VoucherType type;

  VoucherModel({
    required this.id,
    required this.voucherNumber,
    required this.date,
    required this.amount,
    required this.accountId,
    required this.treasuryId,
    required this.note,
    required this.type,
  });
}