import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final bool keepMeSignedIn;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.keepMeSignedIn = false,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? keepMeSignedIn,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      keepMeSignedIn: keepMeSignedIn ?? this.keepMeSignedIn,
      errorMessage: clearError
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    keepMeSignedIn,
    errorMessage,
  ];
}