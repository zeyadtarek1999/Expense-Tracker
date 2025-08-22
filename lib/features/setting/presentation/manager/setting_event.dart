part of 'setting_bloc.dart';

@immutable
sealed class SettingEvent {
  const SettingEvent();
}

class SettingInit extends SettingEvent {
  final String languageCode;
  const SettingInit(this.languageCode);
}

class SettingChangeLanguageRequested extends SettingEvent {
  final String languageCode;
  const SettingChangeLanguageRequested(this.languageCode);
}

class SettingLogoutRequested extends SettingEvent {
  const SettingLogoutRequested();
}
