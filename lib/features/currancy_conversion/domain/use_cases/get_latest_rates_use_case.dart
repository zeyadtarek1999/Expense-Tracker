import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/exchange_rate_entity.dart';
import '../repositories/currency_repository.dart';

class GetLatestRatesParams {
  final String baseCode;
  const GetLatestRatesParams({required this.baseCode});
}

class GetLatestRatesUseCase {
  final CurrencyRepository repository;
  const GetLatestRatesUseCase(this.repository);

  Future<Either<Failure, ExchangeRateEntity>> call(
      GetLatestRatesParams params,
      ) {
    return repository.getLatestRates(baseCode: params.baseCode);
  }
}
