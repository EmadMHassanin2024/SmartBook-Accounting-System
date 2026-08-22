import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/features/auth/auth_exports.dart';
import '../../../services/AuthService.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final TokenRepository _tokenRepository;

  AuthCubit(this._tokenRepository) : super(const AuthState());

  // ============================================================
  // Keep Me Signed In
  // ============================================================

  void toggleKeepMeSignedIn(bool value) {
    emit(
      state.copyWith(
        status: AuthStatus.initial,
        keepMeSignedIn: value,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // Register
  // ============================================================

  Future<void> registerUser(UserModel user) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
      ),
    );

    try {
      final response = await AuthService.register(user);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(
          state.copyWith(
            status: AuthStatus.success,
            clearError: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'فشل التسجيل: ${response.body}',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'خطأ في الاتصال: $e',
        ),
      );
    }
  }

  // ============================================================
  // Login
  // ============================================================

  Future<void> loginUser(UserModel user) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
      ),
    );

    try {
      final response = await AuthService.login(user);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final token = responseData['token'] ??
            responseData['data']?['token'];

        if (token != null) {
          await _tokenRepository.saveToken(token);

          debugPrint(
            'تم حفظ التوكن بنجاح عبر TokenRepository',
          );
        }

        emit(
          state.copyWith(
            status: AuthStatus.success,
            clearError: true,
          ),
        );
      } else {
        final errorMessage = _handleError(response.statusCode);

        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: errorMessage,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'تعذر الاتصال بالسيرفر.',
        ),
      );
    }
  }

  // ============================================================
  // Error Handling
  // ============================================================

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'البيانات المدخلة غير صحيحة';
      case 401:
        return 'اسم المستخدم أو كلمة المرور غير صحيحة';
      case 403:
        return 'ليس لديك صلاحية لتنفيذ هذه العملية';
      case 404:
        return 'الخدمة المطلوبة غير موجودة';
      case 500:
        return 'خطأ داخلي في السيرفر';
      default:
        return 'حدث خطأ غير متوقع ($statusCode)';
    }
  }
}