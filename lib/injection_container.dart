import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:expense_tracker/core/services/permission_service.dart';
 import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/helpers/shared_prefrences.dart';
import 'core/helpers/sql_database.dart';
import 'core/network/netwok_info.dart';
import 'core/services/alert_service.dart';
import 'core/services/url_launcher_service.dart';
import 'features/add_expenses/data/data_sources/add_expenses_local_data_source.dart';
import 'features/add_expenses/data/repositories/expenses_repository_impl.dart';
import 'features/add_expenses/domain/repositories/expenses_repository.dart';
import 'features/add_expenses/domain/use_cases/add_expense_use_case.dart';
import 'features/add_expenses/domain/use_cases/get_recent_expenses_use_case.dart';
import 'features/add_expenses/domain/use_cases/get_total_expenses_use_case.dart';
import 'features/add_expenses/domain/use_cases/get_total_income_use_case.dart';
import 'features/add_expenses/presentation/manager/add_expenses_bloc.dart';
import 'features/currancy_conversion/data/data_sources/currancy_conversion_remote_data_source.dart';
import 'features/currancy_conversion/data/repositories/currency_repository_impl.dart';
import 'features/currancy_conversion/domain/repositories/currency_repository.dart';
import 'features/currancy_conversion/domain/use_cases/get_latest_rates_use_case.dart';
import 'features/currancy_conversion/presentation/manager/currency_conversion_bloc.dart';
import 'features/dashboard/presentation/manager/dashboard_bloc.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/setting/presentation/manager/setting_bloc.dart';

final getIt = GetIt.instance;

Future<void> getItInit() async {
  //! Features

  /// Blocs
  // getIt.registerFactory<CatFactCubit>(() => CatFactCubit(featureUc: getIt()));
  getIt.registerFactory<AddExpensesBloc>(() => AddExpensesBloc(getIt<AddExpenseUseCase>()));
  getIt.registerFactory<DashboardBloc>(() => DashboardBloc(
    getIt<GetRecentExpensesUseCase>(),

  ));
  getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt<CacheHelper>()));
  getIt.registerFactory<SettingBloc>(
        () => SettingBloc(getIt<CacheHelper>()),
  );

  getIt.registerFactory<CurrencyConversionBloc>(
        () => CurrencyConversionBloc(getIt<GetLatestRatesUseCase>()),
  );
  /// Use cases
  // getIt
  //     .registerLazySingleton<FirstFeatureUc>(() => FirstFeatureUc(firstFeatureRepository: getIt()));
  getIt.registerLazySingleton<AddExpenseUseCase>(
        () => AddExpenseUseCase(getIt<ExpensesRepository>()),
  );
  getIt.registerLazySingleton<GetRecentExpensesUseCase>(
        () => GetRecentExpensesUseCase(getIt<ExpensesRepository>()),
  );
  getIt.registerLazySingleton<GetTotalIncomeUseCase>(
        () => GetTotalIncomeUseCase(getIt<ExpensesRepository>()),
  );
  getIt.registerLazySingleton<GetTotalExpensesAbsUseCase>(
        () => GetTotalExpensesAbsUseCase(getIt<ExpensesRepository>()),
  );
  getIt.registerLazySingleton<GetLatestRatesUseCase>(
        () => GetLatestRatesUseCase(getIt<CurrencyRepository>()),
  );
  /// Repository
  // getIt.registerLazySingleton<FirstFeatureRepository>(() =>
  //     FirstFeatureRepositoryImpl(networkInfo: getIt(), firstFeatureRemoteDataSource: getIt()));
  getIt.registerLazySingleton<ExpensesRepository>(
        () => ExpensesRepositoryImpl(getIt<ExpensesLocalDataSource>()),
  );
  getIt.registerLazySingleton<CurrencyRepository>(
        () => CurrencyRepositoryImpl(remote: getIt<CurrencyRemoteDataSource>()),
  );
  /// Data Sources
  // getIt.registerLazySingleton<FirstFeatureRemoteDataSource>(
  //     () => FirstFeatureRemoteDataSourceImpl(client: getIt()));

  getIt.registerLazySingleton<ExpensesLocalDataSource>(
        () => ExpensesLocalDataSourceImpl(  getIt<SqlDatabase>()),
  );
  getIt.registerLazySingleton<CurrencyRemoteDataSource>(
        () => CurrencyRemoteDataSourceImpl(
      client: getIt<ApiConsumer>(),
          apiKey: getIt<String>(instanceName: 'currencyApiKey'),
    ),
  );
  /// Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: getIt()));
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: getIt()));
  getIt.registerLazySingleton<String>(
        () => 'a57fc538a31abcc795683789',
    instanceName: 'currencyApiKey',
  );

  /// External
  SharedPreferences preferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => preferences);
  getIt.registerLazySingleton(() => AppInterceptors());
  // getIt.registerLazySingleton(() => LogInterceptor(
  //     request: true,
  //     requestBody: true,
  //     requestHeader: true,
  //     responseBody: true,
  //     responseHeader: false,
  //     error: true));
  getIt.registerLazySingleton(() => InternetConnectionChecker());
  getIt.registerLazySingleton(() => CacheHelper());
  getIt.registerLazySingleton(() => UrlLauncherService());
  getIt.registerLazySingleton(() => PermissionService());
  getIt.registerLazySingleton(() => AlertService());
  getIt.registerLazySingleton<SqlDatabase>(() => SqlDatabase());

  getIt.registerLazySingleton(() => PrettyDioLogger(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ));
  getIt.registerLazySingleton(() => Dio());
}
