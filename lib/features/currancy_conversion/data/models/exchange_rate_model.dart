// lib/features/currancy_conversion/data/models/exchange_rate_model.dart
import '../../domain/entities/exchange_rate_entity.dart';

class ExchangeRateModel extends ExchangeRateEntity {
  final String? documentation;
  final String? termsOfUse;

  const ExchangeRateModel({
    required String result,
    required String baseCode,
    required int timeLastUpdateUnix,
    required String timeLastUpdateUtc,
    required int timeNextUpdateUnix,
    required String timeNextUpdateUtc,
    required Map<String, double> conversionRates,
    this.documentation,
    this.termsOfUse,
  }) : super(
    result: result,
    baseCode: baseCode,
    timeLastUpdateUnix: timeLastUpdateUnix,
    timeLastUpdateUtc: timeLastUpdateUtc,
    timeNextUpdateUnix: timeNextUpdateUnix,
    timeNextUpdateUtc: timeNextUpdateUtc,
    conversionRates: conversionRates,
  );

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    final rawRates = (json['conversion_rates'] as Map?) ?? const {};
    final rates = <String, double>{};
    rawRates.forEach((k, v) {
      if (v is num) {
        rates[k.toString()] = v.toDouble();
      } else if (v is String) {
        final parsed = double.tryParse(v);
        if (parsed != null) rates[k.toString()] = parsed;
      }
    });

    return ExchangeRateModel(
      result: (json['result'] as String?)?.trim() ?? '',
      baseCode: (json['base_code'] as String?)?.trim() ?? '',
      timeLastUpdateUnix: ((json['time_last_update_unix'] as num?) ?? 0).toInt(),
      timeLastUpdateUtc: (json['time_last_update_utc'] as String?)?.trim() ?? '',
      timeNextUpdateUnix: ((json['time_next_update_unix'] as num?) ?? 0).toInt(),
      timeNextUpdateUtc: (json['time_next_update_utc'] as String?)?.trim() ?? '',
      conversionRates: rates,
      documentation: (json['documentation'] as String?)?.trim(),
      termsOfUse: (json['terms_of_use'] as String?)?.trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'documentation': documentation,
      'terms_of_use': termsOfUse,
      'time_last_update_unix': timeLastUpdateUnix,
      'time_last_update_utc': timeLastUpdateUtc,
      'time_next_update_unix': timeNextUpdateUnix,
      'time_next_update_utc': timeNextUpdateUtc,
      'base_code': baseCode,
      'conversion_rates': conversionRates,
    };
  }
}
