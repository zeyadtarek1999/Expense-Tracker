import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/currancy_conversion/domain/entities/exchange_rate_entity.dart';
import 'package:expense_tracker/features/currancy_conversion/domain/use_cases/get_latest_rates_use_case.dart';
import 'package:expense_tracker/features/currancy_conversion/presentation/manager/currency_conversion_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLatestRatesUseCase extends Mock implements GetLatestRatesUseCase {}
class FakeGetLatestRatesParams extends Fake implements GetLatestRatesParams {}

void main() {
  late MockGetLatestRatesUseCase mockGetLatestRates;

  setUpAll(() {
    registerFallbackValue(FakeGetLatestRatesParams());
  });

  setUp(() {
    mockGetLatestRates = MockGetLatestRatesUseCase();
  });

  ExchangeRateEntity usdRates({
    double egp = 50.0,
    double eur = 0.9,
    double sar = 3.75,
    int ts = 1724280000,
  }) {
    return ExchangeRateEntity(
      result: 'success',
      baseCode: 'USD',
      timeLastUpdateUnix: ts,
      timeLastUpdateUtc: '2024-08-21 00:00 UTC',
      timeNextUpdateUnix: ts + 3600,
      timeNextUpdateUtc: '2024-08-21 01:00 UTC',
      conversionRates: {
        'EGP': egp,
        'EUR': eur,
        'SAR': sar,
      },
    );
  }

  ExchangeRateEntity eurRates({
    double usd = 1.11,
    double egp = 55.0,
    int ts = 1724280000,
  }) {
    return ExchangeRateEntity(
      result: 'success',
      baseCode: 'EUR',
      timeLastUpdateUnix: ts,
      timeLastUpdateUtc: '2024-08-21 00:00 UTC',
      timeNextUpdateUnix: ts + 3600,
      timeNextUpdateUtc: '2024-08-21 01:00 UTC',
      conversionRates: {
        'USD': usd,
        'EGP': egp,
      },
    );
  }

  group('CurrencyConversionBloc', () {
    blocTest<CurrencyConversionBloc, CurrencyConversionState>(
      'FetchLatestRates success -> loading then loaded',
      build: () {
        when(() => mockGetLatestRates(any())).thenAnswer((_) async => Right(usdRates()));
        return CurrencyConversionBloc(mockGetLatestRates);
      },
      act: (b) {
        print('Running: fetch success');
        b.add(const FetchLatestRates(baseCode: 'USD'));
      },
      wait: const Duration(milliseconds: 5),
      expect: () => [
        isA<CurrencyConversionState>().having((s) => s.loading, 'loading', true),
        isA<CurrencyConversionState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.baseCode, 'base', 'USD')
            .having((s) => s.rates['EGP'], 'EGP rate', isNonZero),
      ],
      verify: (b) {
        print('Final: base=${b.state.baseCode}, EGP=${b.state.rates['EGP']}');
        verify(() => mockGetLatestRates(any())).called(1);
      },
    );

    blocTest<CurrencyConversionBloc, CurrencyConversionState>(
      'FetchLatestRates failure -> loading then error',
      build: () {
        when(() => mockGetLatestRates(any())).thenAnswer((_) async => Left(ServerFailure('No Internet')));
        return CurrencyConversionBloc(mockGetLatestRates);
      },
      act: (b) {
        print('Running: fetch failure');
        b.add(const FetchLatestRates(baseCode: 'USD'));
      },
      wait: const Duration(milliseconds: 5),
      expect: () => [
        isA<CurrencyConversionState>().having((s) => s.loading, 'loading', true),
        isA<CurrencyConversionState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.error, 'error', isNotNull),
      ],
      verify: (b) => print('Final error: ${b.state.error}'),
    );

    blocTest<CurrencyConversionBloc, CurrencyConversionState>(
      'UpdateFromCurrency -> updates fromCurrency then triggers fetch',
      build: () {
        when(() => mockGetLatestRates(any())).thenAnswer((_) async => Right(eurRates()));
        return CurrencyConversionBloc(mockGetLatestRates);
      },
      act: (b) {
        print('Running: update from');
        b.add(const UpdateFromCurrency('EUR'));
      },
      wait: const Duration(milliseconds: 5),
      expect: () => [
        isA<CurrencyConversionState>()
            .having((s) => s.fromCurrency, 'from', 'EUR')
            .having((s) => s.result, 'result', '')
            .having((s) => s.error, 'error', isNull),
        isA<CurrencyConversionState>().having((s) => s.loading, 'loading', true),
        isA<CurrencyConversionState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.baseCode, 'base', 'EUR')
            .having((s) => s.rates['USD'], 'USD rate', isNonZero),
      ],
      verify: (b) {
        print('Final: base=${b.state.baseCode}, USD=${b.state.rates['USD']}');
        verify(() => mockGetLatestRates(any())).called(1);
      },
    );

    blocTest<CurrencyConversionBloc, CurrencyConversionState>(
      'UpdateToCurrency -> updates toCurrency and clears result/error',
      build: () => CurrencyConversionBloc(mockGetLatestRates),
      act: (b) {
        print('Running: update to');
        b.add(const UpdateToCurrency('EGP'));
      },
      expect: () => [
        isA<CurrencyConversionState>()
            .having((s) => s.toCurrency, 'to', 'EGP')
            .having((s) => s.result, 'result', '')
            .having((s) => s.error, 'error', isNull),
      ],
      verify: (b) => print('Final: to=${b.state.toCurrency}'),
    );

    blocTest<CurrencyConversionBloc, CurrencyConversionState>(
      'SwapCurrencies -> swaps and fetches new base',
      build: () {
        when(() => mockGetLatestRates(any())).thenAnswer((_) async => Right(usdRates()));
        final bloc = CurrencyConversionBloc(mockGetLatestRates);
        bloc.emit(bloc.state.copyWith(fromCurrency: 'USD', toCurrency: 'EGP'));
        return bloc;
      },
      act: (b) {
        print('Running: swap');
        b.add(const SwapCurrencies());
      },
      wait: const Duration(milliseconds: 5),
      expect: () => [
        isA<CurrencyConversionState>()
            .having((s) => s.fromCurrency, 'from', 'EGP')
            .having((s) => s.toCurrency, 'to', 'USD')
            .having((s) => s.result, 'result', ''),
        isA<CurrencyConversionState>().having((s) => s.loading, 'loading', true),
        isA<CurrencyConversionState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.baseCode, 'base', 'USD')
            .having((s) => s.rates['EGP'], 'EGP rate', isNonZero),
      ],
      verify: (b) {
        print('Final: from=${b.state.fromCurrency}, to=${b.state.toCurrency}');
        verify(() => mockGetLatestRates(any())).called(1);
      },
    );

    blocTest<CurrencyConversionBloc, CurrencyConversionState>(
      'UpdateAmount -> stores amount text and clears result/error',
      build: () => CurrencyConversionBloc(mockGetLatestRates),
      act: (b) {
        print('Running: update amount');
        b.add(const UpdateAmount('123.45'));
      },
      expect: () => [
        isA<CurrencyConversionState>()
            .having((s) => s.amountText, 'amountText', '123.45')
            .having((s) => s.result, 'result', '')
            .having((s) => s.error, 'error', isNull),
      ],
      verify: (b) => print('Final: amount=${b.state.amountText}'),
    );

    blocTest<CurrencyConversionBloc, CurrencyConversionState>(
      'ConvertPressed: amount <= 0 returns "0 <toCurrency>"',
      build: () {
        final bloc = CurrencyConversionBloc(mockGetLatestRates);
        bloc.emit(bloc.state.copyWith(toCurrency: 'EGP', amountText: '0'));
        return bloc;
      },
      act: (b) {
        print('Running: convert <= 0');
        b.add(const ConvertPressed());
      },
      expect: () => [
        isA<CurrencyConversionState>()
            .having((s) => s.result, 'result', '0 EGP')
            .having((s) => s.error, 'error', isNull),
      ],
      verify: (b) => print('Final: result=${b.state.result}'),
    );

    blocTest<CurrencyConversionBloc, CurrencyConversionState>(
      'ConvertPressed: uses cached rates when base matches (no new fetch)',
      build: () {
        when(() => mockGetLatestRates(any())).thenAnswer((_) async => Right(usdRates(egp: 50.0)));
        return CurrencyConversionBloc(mockGetLatestRates);
      },
      act: (b) async {
        print('Running: convert cached');
        b.add(const FetchLatestRates(baseCode: 'USD'));
        await Future.delayed(const Duration(milliseconds: 5));
        b.emit(b.state.copyWith(fromCurrency: 'USD', toCurrency: 'EGP', amountText: '2'));
        b.add(const ConvertPressed());
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        isA<CurrencyConversionState>().having((s) => s.loading, 'loading', true),
        isA<CurrencyConversionState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.baseCode, 'base', 'USD')
            .having((s) => s.rates['EGP'], 'EGP rate', 50.0),
        isA<CurrencyConversionState>()
            .having((s) => s.fromCurrency, 'from', 'USD')
            .having((s) => s.toCurrency, 'to', 'EGP')
            .having((s) => s.amountText, 'amount', '2')
            .having((s) => s.error, 'error', isNull),
        isA<CurrencyConversionState>()
            .having((s) => s.result, 'result', '100 EGP')
            .having((s) => s.error, 'error', isNull),
      ],
      verify: (b) {
        print('Final: result=${b.state.result}');
        verify(() => mockGetLatestRates(any())).called(1);
      },
    );

    blocTest<CurrencyConversionBloc, CurrencyConversionState>(
      'ConvertPressed: fetches when base stale/rates empty, then converts',
      build: () {
        when(() => mockGetLatestRates(any())).thenAnswer((_) async => Right(eurRates(usd: 1.2)));
        final bloc = CurrencyConversionBloc(mockGetLatestRates);
        bloc.emit(bloc.state.copyWith(
          baseCode: 'USD',
          fromCurrency: 'EUR',
          toCurrency: 'USD',
          rates: const {},
          amountText: '3',
        ));
        return bloc;
      },
      act: (b) {
        print('Running: convert fetch then convert');
        b.add(const ConvertPressed());
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        isA<CurrencyConversionState>().having((s) => s.loading, 'loading', true),
        isA<CurrencyConversionState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.baseCode, 'base', 'EUR')
            .having((s) => s.rates['USD'], 'USD rate', 1.2),
        isA<CurrencyConversionState>()
            .having((s) => s.result, 'result', '3.6 USD'),
      ],
      verify: (b) {
        print('Final: result=${b.state.result}');
        verify(() => mockGetLatestRates(any())).called(1);
      },
    );

    blocTest<CurrencyConversionBloc, CurrencyConversionState>(
      'ConvertPressed: error when target rate missing',
      build: () {
        when(() => mockGetLatestRates(any())).thenAnswer((_) async => Right(usdRates(egp: 50.0)));
        return CurrencyConversionBloc(mockGetLatestRates);
      },
      act: (b) async {
        print('Running: convert missing rate');
        b.add(const FetchLatestRates(baseCode: 'USD'));
        await Future.delayed(const Duration(milliseconds: 5));
        b.emit(b.state.copyWith(fromCurrency: 'USD', toCurrency: 'JPY', amountText: '5'));
        b.add(const ConvertPressed());
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        isA<CurrencyConversionState>().having((s) => s.loading, 'loading', true),
        isA<CurrencyConversionState>().having((s) => s.loading, 'loading', false),
        isA<CurrencyConversionState>()
            .having((s) => s.fromCurrency, 'from', 'USD')
            .having((s) => s.toCurrency, 'to', 'JPY')
            .having((s) => s.amountText, 'amount', '5')
            .having((s) => s.error, 'error', isNull),
        isA<CurrencyConversionState>()
            .having((s) => s.error, 'error', 'Rate not available for JPY'),
      ],
      verify: (b) {
        print('Selected: ${b.state.fromCurrency} -> ${b.state.toCurrency}, amount=${b.state.amountText}');
        print('Final: ${b.state.result.isNotEmpty ? b.state.result : b.state.error}');
        verify(() => mockGetLatestRates(any())).called(1);
      },
    );
  });
}

final isNonZero = isA<num>().having((n) => n != 0, 'non-zero', true);
