import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/exchange_rate_entity.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, ExchangeRateEntity>> getLatestRates({
    required String baseCode,
  });
}
