/*
class Account {

  final int id;
  final String name;
  final String accountType; // (أصل، خصم، مصروف، إيراد)
  final double currentBalance;

  Account({
    required this.id,
    required this.name,
    required this.accountType,
    required this.currentBalance,
  });

  // تحويل البيانات من JSON (القادمة من الـ API) إلى كائن Account
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'غير معروف',
      accountType: json['accountType'] ?? 'غير مصنف',
      currentBalance: (json['currentBalance'] ?? 0.0).toDouble(),
    );
  }
}
 */