

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  //طريقة سهلة لجعل Dart تقارن محتوى الكائنات بدل مقارنة أماكنها في الذاكرة
  //عند المقارنة، انظر فقط إلى message.
  List<Object?> get props => [];
}

class AuthKeepMeSignedInChanged extends AuthState {
  final bool isChecked;

  const AuthKeepMeSignedInChanged(this.isChecked);

  @override
  List<Object?> get props => [isChecked];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}