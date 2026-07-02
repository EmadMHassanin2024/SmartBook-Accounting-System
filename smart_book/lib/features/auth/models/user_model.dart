class UserModel {
  final String username;
  final String password;
  final String? fullName;

  UserModel({
    required this.username,
    required this.password,
    this.fullName,
  });

  // تحويل الكلاس إلى Map لإرساله للسيرفر (JSON)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "username": username,
      "password": password,
    };

    // نرسل الـ fullName فقط إذا كان له قيمة (في حالة التسجيل)
    if (fullName != null && fullName!.isNotEmpty) {
      data["fullName"] = fullName;
    }

    return data;
  }
  }
