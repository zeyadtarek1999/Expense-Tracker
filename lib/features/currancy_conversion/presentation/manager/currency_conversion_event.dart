// lib/features/currancy_conversion/presentation/manager/currency_conversion_event.dart
part of 'currency_conversion_bloc.dart';

@immutable
sealed class CurrencyConversionEvent {
  const CurrencyConversionEvent();
}

class FetchLatestRates extends CurrencyConversionEvent {
  final String baseCode;
  const FetchLatestRates({required this.baseCode});
}

class UpdateFromCurrency extends CurrencyConversionEvent {
  final String currency;
  const UpdateFromCurrency(this.currency);
}

class UpdateToCurrency extends CurrencyConversionEvent {
  final String currency;
  const UpdateToCurrency(this.currency);
}

class SwapCurrencies extends CurrencyConversionEvent {
  const SwapCurrencies();
}

class UpdateAmount extends CurrencyConversionEvent {
  final String text;
  const UpdateAmount(this.text);
}

class ConvertPressed extends CurrencyConversionEvent {
  const ConvertPressed();
}
