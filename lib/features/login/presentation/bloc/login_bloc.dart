 import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_constants/arg_keys.dart';
import '../../../../core/helpers/shared_prefrences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final formKey = GlobalKey<FormState>();
  final CacheHelper cache;

  LoginBloc(this.cache) : super(LoginState.initial()) {
    on<InitLoginEvent>(onInit);
    on<EmailChanged>(onEmailChanged);
    on<PasswordChanged>(onPasswordChanged);
    on<TogglePasswordVisibility>(onToggleObscure);
    on<SubmitPressed>(onSubmit);
  }

  FutureOr<void> onInit(InitLoginEvent event, Emitter<LoginState> emit) {
    emit(state);
  }

  FutureOr<void> onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, error: null));
  }

  FutureOr<void> onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password, error: null));
  }

  FutureOr<void> onToggleObscure(TogglePasswordVisibility event, Emitter<LoginState> emit) {
    emit(state.copyWith(obscure: !state.obscure));
  }

  Future<void> onSubmit(SubmitPressed event, Emitter<LoginState> emit) async {
    final isFormValid = formKey.currentState?.validate() ?? true;
    if (!isFormValid) return;
    if (!state.canSubmit) return;

    emit(state.copyWith(loading: true, error: null, success: false));
    await Future.delayed(const Duration(milliseconds: 900));

    final ok = state.isEmailValid && state.isPasswordValid;

     if (ok) {
      await cache.saveData(key: AppArgKey.isLoggedIn, val: true);
    }

    emit(state.copyWith(
      loading: false,
      success: ok,
      error: ok ? null : 'Invalid credentials',
    ));
  }
}
