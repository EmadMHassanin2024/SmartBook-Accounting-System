import 'package:smart_book/features/auth/auth_exports.dart';

import '../../../services/AuthService.dart';

class AuthCubit extends Cubit<AuthState> {
  final TokenRepository _tokenRepository;
  AuthCubit(this._tokenRepository) : super(AuthInitial());

  // داخل AuthCubit
  bool keepMeSignedIn = false; // المتغير الأساسي

  void toggleKeepMeSignedIn(bool value) {
    keepMeSignedIn = value;

    emit(AuthKeepMeSignedInChanged(value));
  }
  // دالة التسجيل
  Future<void> registerUser(UserModel user) async {
    emit(AuthLoading());
    try {
      final response = await AuthService.register(user);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AuthSuccess());
      } else {
        emit(AuthError("فشل التسجيل: ${response.body}"));
      }
    } catch (e) {
      emit(AuthError("خطأ في الاتصال: $e"));
    }
  }

  // 🚀 دالة تسجيل الدخول المحدثة
  Future<void> loginUser(UserModel user) async {
    emit(AuthLoading());
    try {
      final response = await AuthService.login(user);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // استخراج التوكن
        final token = responseData['token'] ?? responseData['data']?['token'];

        if (token != null) {
          // 🎯 استخدام الـ Repository بدلاً من الـ storage مباشرة
          await _tokenRepository.saveToken(token);
          debugPrint("🔑 تم حفظ التوكن بنجاح عبر الـ TokenRepository!");
        }

        emit(AuthSuccess());
      } else {
        // معالجة الأخطاء بناءً على كود السيرفر
        final errorMessage = _handleError(response.statusCode);
        emit(AuthError(errorMessage));
      }
    } catch (e) {

      emit(AuthError("تعذر الاتصال بالسيرفر."));
    }
  }

  // دالة مساعدة لمعالجة كود الخطأ
  String _handleError(int statusCode) {
    switch (statusCode) {
      case 401: return "اسم المستخدم أو كلمة المرور غير صحيحة";
      case 500: return "خطأ داخلي في السيرفر";
      default: return "حدث خطأ غير متوقع ($statusCode)";
    }
  }
}