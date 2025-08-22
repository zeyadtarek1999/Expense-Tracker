part of 'setting_bloc.dart';

enum SettingStatus { idle, loading, languageChanged, logoutSuccess, error }

@immutable
class SettingState {
  final String languageCode;
  final SettingStatus status;
  final String? errorMessage;

  const SettingState({
    required this.languageCode,
    required this.status,
    this.errorMessage,
  });

  const SettingState.initial()
      : languageCode = 'en',
        status = SettingStatus.idle,
        errorMessage = null;

  SettingState copyWith({
    String? languageCode,
    SettingStatus? status,
    String? errorMessage,
  }) {
    return SettingState(
      languageCode: languageCode ?? this.languageCode,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
