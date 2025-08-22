part of 'login_bloc.dart';

abstract class LoginEvent {}

class InitLoginEvent extends LoginEvent {}

class EmailChanged extends LoginEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);
}

class TogglePasswordVisibility extends LoginEvent {}

class SubmitPressed extends LoginEvent {}
