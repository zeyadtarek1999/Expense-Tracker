import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/exchange_rate_entity.dart';
import '../../domain/repositories/currency_repository.dart';
import '../data_sources/currancy_conversion_remote_data_source.dart';
import '../models/exchange_rate_model.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remote;

  CurrencyRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, ExchangeRateEntity>> getLatestRates({
    required String baseCode,
  }) async {
    final Either<Failure, ExchangeRateModel> res =
    await remote.getLatestRates(baseCode: baseCode);

     return res.map<ExchangeRateEntity>((model) => model);
  }
}
