class UserModel {
  late final String id;
  late final String name;
  final BusinessModule assignedModule; // 👈 النشاط المخصص لهذا المستخدم (مثل الصيدلية)
  final List<String> permissions; // أو قائمة الصلاحيات

// ... البقية
}