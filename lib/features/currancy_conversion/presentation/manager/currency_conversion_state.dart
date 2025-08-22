// lib/features/currancy_conversion/presentation/manager/currency_conversion_state.dart
part of 'currency_conversion_bloc.dart';

@immutable
class CurrencyConversionState {
  final String fromCurrency;
  final String toCurrency;
  final String amountText;
  final String result;
  final String baseCode;
  final Map<String, double> rates;
  final bool loading;
  final String? error;
  final DateTime? lastUpdated;

  const CurrencyConversionState({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amountText,
    required this.result,
    required this.baseCode,
    required this.rates,
    required this.loading,
    required this.error,
    required this.lastUpdated,
  });

  factory CurrencyConversionState.initial() => const CurrencyConversionState(
    fromCurrency: 'USD',
    toCurrency: 'EGP',
    amountText: '',
    result: '',
    baseCode: 'USD',
    rates: {},
    loading: false,
    error: null,
    lastUpdated: null,
  );

  CurrencyConversionState copyWith({
    String? fromCurrency,
    String? toCurrency,
    String? amountText,
    String? result,
    String? baseCode,
    Map<String, double>? rates,
    bool? loading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return CurrencyConversionState(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amountText: amountText ?? this.amountText,
      result: result ?? this.result,
      baseCode: baseCode ?? this.baseCode,
      rates: rates ?? this.rates,
      loading: loading ?? this.loading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
