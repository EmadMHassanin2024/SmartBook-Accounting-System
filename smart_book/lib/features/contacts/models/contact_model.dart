class ContactModel {
  final String id;
  final String name;
  final String phone;
  final String taxNumber; // الرقم الضريبي
  final double openingBalance; // الرصيد الافتتاحي
  final double currentBalance; // الرصيد الحالي
  final String type; // 'customer' أو 'supplier'

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.taxNumber,
    required this.openingBalance,
    required this.currentBalance,
    required this.type,
  });

  // تحويل البيانات من Map (القادمة من API مستقبلاً) إلى كائن برمجى
  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      taxNumber: map['taxNumber'] ?? '',
      openingBalance: (map['openingBalance'] ?? 0.0).toDouble(),
      currentBalance: (map['currentBalance'] ?? 0.0).toDouble(),
      type: map['type'],
    );
  }
}