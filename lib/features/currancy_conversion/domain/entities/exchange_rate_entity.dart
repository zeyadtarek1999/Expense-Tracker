class ExchangeRateEntity {
  final String result;
  final String baseCode;

  // timestamps from API
  final int timeLastUpdateUnix;
  final String timeLastUpdateUtc;
  final int timeNextUpdateUnix;
  final String timeNextUpdateUtc;

  // rates: e.g. {"USD":1, "EUR":0.86, ...}
  final Map<String, double> conversionRates;

  const ExchangeRateEntity({
    required this.result,
    required this.baseCode,
    required this.timeLastUpdateUnix,
    required this.timeLastUpdateUtc,
    required this.timeNextUpdateUnix,
    required this.timeNextUpdateUtc,
    required this.conversionRates,
  });

  ExchangeRateEntity copyWith({
    String? result,
    String? baseCode,
    int? timeLastUpdateUnix,
    String? timeLastUpdateUtc,
    int? timeNextUpdateUnix,
    String? timeNextUpdateUtc,
    Map<String, double>? conversionRates,
  }) {
    return ExchangeRateEntity(
      result: result ?? this.result,
      baseCode: baseCode ?? this.baseCode,
      timeLastUpdateUnix: timeLastUpdateUnix ?? this.timeLastUpdateUnix,
      timeLastUpdateUtc: timeLastUpdateUtc ?? this.timeLastUpdateUtc,
      timeNextUpdateUnix: timeNextUpdateUnix ?? this.timeNextUpdateUnix,
      timeNextUpdateUtc: timeNextUpdateUtc ?? this.timeNextUpdateUtc,
      conversionRates: conversionRates ?? this.conversionRates,
    );
  }
}
