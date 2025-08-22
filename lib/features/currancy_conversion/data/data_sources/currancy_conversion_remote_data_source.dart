 import 'dart:developer';
import 'package:dartz/dartz.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/error/failures.dart';
import '../models/exchange_rate_model.dart';

abstract class CurrencyRemoteDataSource {
  Future<Either<Failure, ExchangeRateModel>> getLatestRates({
    required String baseCode,
  });
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final ApiConsumer client;
  final String apiKey;

  CurrencyRemoteDataSourceImpl({
    required this.client,
    required this.apiKey,
  });

  @override
  Future<Either<Failure, ExchangeRateModel>> getLatestRates({
    required String baseCode,
  }) async {
    try {
      final url = EndPoints.currencyLatestRates(apiKey, baseCode.toUpperCase());
      final response = await client.get(url);

      final model = ExchangeRateModel.fromJson(
        response as Map<String, dynamic>,
      );

      if (model.result.toLowerCase() != 'success') {
        final type = (response)['error-type'];
        return Left(ServerFailure('Exchange API error: ${type ?? 'unknown'}'));
      }

      return Right(model);
    } catch (e, st) {
      log('Error in getLatestRates: $e', stackTrace: st);
      return Left(ServerFailure(e.toString()));
    }
  }
}
