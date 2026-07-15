import 'package:equatable/equatable.dart';

// جعل النموذج يرث من Equatable لتمكين مقارنة القيم
class ContactModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String taxNumber; // الرقم الضريبي
  final double openingBalance; // الرصيد الافتتاحي
  final double currentBalance; // الرصيد الحالي
  final String type; // 'customer' أو 'supplier'

  // الكونستركتور الأساسي
  const ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.taxNumber,
    required this.openingBalance,
    required this.currentBalance,
    required this.type,
  });

  // 1. Factory Constructor لتحويل البيانات من Map (استجابة API) إلى كائن
  // تم تحديث المفاتيح لتطابق أسماء الأعمدة في قاعدة بيانات SQL Server
  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: (map['contactId'] ?? map['ContactID'])?.toString() ?? '',
      name: map['name'] ?? map['Name'] ?? 'بدون اسم',
      phone: map['phone'] ?? map['Phone'] ?? '0123556',
      taxNumber: map['taxNumber'] ?? map['TaxNumber'] ?? '',
      openingBalance: (map['openingBalance'] ?? map['OpeningBalance'] ?? 0.0).toDouble(),
      currentBalance: (map['currentBalance'] ?? map['CurrentBalance'] ?? 0.0).toDouble(),
      type: map['contactType'] ?? map['ContactType'] ?? '',
    );
  }

  // 2. دالة toMap: لتحويل الكائن إلى Map (لإرساله إلى API)
  // هذه الأسماء يجب أن تتطابق تماماً مع ما يتوقعه الـ API/Database
  Map<String, dynamic> toMap() {
    return {

      'Name': name,
      'Phone': phone,
      'TaxNumber': taxNumber,
      'OpeningBalance': openingBalance,
      'CurrentBalance': currentBalance,
      'ContactType': type,
    };
  }

  // 3. دالة copyWith: لإنشاء نسخة جديدة مع تعديل قيم محددة
  ContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? taxNumber,
    double? openingBalance,
    double? currentBalance,
    String? type,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      taxNumber: taxNumber ?? this.taxNumber,
      openingBalance: openingBalance ?? this.openingBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      type: type ?? this.type,
    );
  }

  // 4. Equatable: لمقارنة الكائنات
  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    taxNumber,
    openingBalance,
    currentBalance,
    type,
  ];
}