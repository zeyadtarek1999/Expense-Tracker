part of 'login_bloc.dart';

class LoginState {
  final String email;
  final String password;
  final bool obscure;
  final bool loading;
  final bool success;
  final String? error;

  bool get isEmailValid =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email.trim());

  bool get isPasswordValid => password.trim().length >= 8;

  bool get canSubmit => isEmailValid && isPasswordValid && !loading;

  const LoginState({
    required this.email,
    required this.password,
    required this.obscure,
    required this.loading,
    required this.success,
    this.error,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      obscure: true,
      loading: false,
      success: false,
      error: null,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscure,
    bool? loading,
    bool? success,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscure: obscure ?? this.obscure,
      loading: loading ?? this.loading,
      success: success ?? this.success,
      error: error,
    );
  }
}
