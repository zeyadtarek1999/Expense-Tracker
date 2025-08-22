import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/app_constants/arg_keys.dart';
import '../../../../core/helpers/shared_prefrences.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final CacheHelper cache;

  SettingBloc(this.cache) : super(const SettingState.initial()) {
    on<SettingInit>(_onInit);
    on<SettingChangeLanguageRequested>(_onChangeLanguage);
    on<SettingLogoutRequested>(_onLogout);
  }

  void _onInit(SettingInit event, Emitter<SettingState> emit) {
    emit(state.copyWith(languageCode: event.languageCode, status: SettingStatus.idle));
  }

  Future<void> _onChangeLanguage(
      SettingChangeLanguageRequested event,
      Emitter<SettingState> emit,
      ) async {
    try {
      emit(state.copyWith(status: SettingStatus.loading));
      // (Optional) persist language if you want to read it on next app start
      await cache.saveData(key: 'app_language_code', val: event.languageCode);
      emit(state.copyWith(languageCode: event.languageCode, status: SettingStatus.languageChanged));
    } catch (e) {
      emit(state.copyWith(status: SettingStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onLogout(
      SettingLogoutRequested event,
      Emitter<SettingState> emit,
      ) async {
    try {
      emit(state.copyWith(status: SettingStatus.loading));
      await cache.saveData(key: AppArgKey.isLoggedIn, val: false);
      emit(state.copyWith(status: SettingStatus.logoutSuccess));
    } catch (e) {
      emit(state.copyWith(status: SettingStatus.error, errorMessage: e.toString()));
    }
  }
}
