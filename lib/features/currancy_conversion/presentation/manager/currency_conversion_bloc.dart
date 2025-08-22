// lib/features/currancy_conversion/presentation/manager/currency_conversion_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/use_cases/get_latest_rates_use_case.dart';

part 'currency_conversion_event.dart';
part 'currency_conversion_state.dart';

class CurrencyConversionBloc extends Bloc<CurrencyConversionEvent, CurrencyConversionState> {
  final GetLatestRatesUseCase getLatestRates;

  CurrencyConversionBloc(this.getLatestRates) : super(CurrencyConversionState.initial()) {
    on<FetchLatestRates>(_onFetchLatestRates);
    on<UpdateFromCurrency>(_onUpdateFromCurrency);
    on<UpdateToCurrency>(_onUpdateToCurrency);
    on<SwapCurrencies>(_onSwapCurrencies);
    on<UpdateAmount>(_onUpdateAmount);
    on<ConvertPressed>(_onConvertPressed);
  }

  Future<void> _onFetchLatestRates(FetchLatestRates event, Emitter<CurrencyConversionState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    final res = await getLatestRates(GetLatestRatesParams(baseCode: event.baseCode));
    await res.fold(
          (failure) async {
        emit(state.copyWith(loading: false, error: failure.massage ?? failure.toString()));
      },
          (entity) async {
        final rates = Map<String, double>.from(entity.conversionRates);
        String to = state.toCurrency;
        if (!rates.containsKey(to)) {
          to = entity.baseCode == 'USD' && rates.containsKey('EGP')
              ? 'EGP'
              : (rates.keys.contains('USD') ? 'USD' : rates.keys.first);
        }
        emit(state.copyWith(
          loading: false,
          error: null,
          baseCode: entity.baseCode,
          rates: rates,
          toCurrency: to,
          lastUpdated: DateTime.fromMillisecondsSinceEpoch(entity.timeLastUpdateUnix * 1000, isUtc: true),
        ));
      },
    );
  }

  Future<void> _onUpdateFromCurrency(UpdateFromCurrency event, Emitter<CurrencyConversionState> emit) async {
    emit(state.copyWith(fromCurrency: event.currency, result: '', error: null));
    add(FetchLatestRates(baseCode: event.currency));
  }

  void _onUpdateToCurrency(UpdateToCurrency event, Emitter<CurrencyConversionState> emit) {
    emit(state.copyWith(toCurrency: event.currency, result: '', error: null));
  }

  void _onSwapCurrencies(SwapCurrencies event, Emitter<CurrencyConversionState> emit) {
    final newFrom = state.toCurrency;
    final newTo = state.fromCurrency;
    emit(state.copyWith(fromCurrency: newFrom, toCurrency: newTo, result: '', error: null));
    add(FetchLatestRates(baseCode: newFrom));
  }

  void _onUpdateAmount(UpdateAmount event, Emitter<CurrencyConversionState> emit) {
    emit(state.copyWith(amountText: event.text, result: '', error: null));
  }

  Future<void> _onConvertPressed(ConvertPressed event, Emitter<CurrencyConversionState> emit) async {
    final amount = double.tryParse(state.amountText.trim()) ?? 0.0;
    if (amount <= 0) {
      emit(state.copyWith(result: '0 ${state.toCurrency}', error: null));
      return;
    }

    Map<String, double> rates = state.rates;
    String base = state.baseCode;

    if (base != state.fromCurrency || rates.isEmpty) {
      emit(state.copyWith(loading: true, error: null));
      final res = await getLatestRates(GetLatestRatesParams(baseCode: state.fromCurrency));
      await res.fold(
            (failure) async {
          emit(state.copyWith(loading: false, error: failure.massage ?? failure.toString()));
        },
            (entity) async {
          rates = Map<String, double>.from(entity.conversionRates);
          base = entity.baseCode;
          emit(state.copyWith(
            loading: false,
            baseCode: base,
            rates: rates,
            error: null,
            lastUpdated: DateTime.fromMillisecondsSinceEpoch(entity.timeLastUpdateUnix * 1000, isUtc: true),
          ));
        },
      );
      if (state.loading) return;
    }

    if (!rates.containsKey(state.toCurrency)) {
      emit(state.copyWith(error: 'Rate not available for ${state.toCurrency}'));
      return;
    }

    final converted = amount * (rates[state.toCurrency] ?? 0);
    emit(state.copyWith(result: _fmt(converted) + ' ${state.toCurrency}', error: null));
  }

  String _fmt(num v) {
    final s = v.toStringAsFixed(6);
    return s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;
  }
}
