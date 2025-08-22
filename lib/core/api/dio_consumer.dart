import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../injection_container.dart';
import '../error/exceptions.dart';
import 'api_consumer.dart';
import 'app_interceptors.dart';
import 'end_points.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    (client.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.json
      ..followRedirects = false
      ..contentType = Headers.jsonContentType;
    // ..validateStatus = (status) {
    //   return status! < StatusCode.internalServerError;
    // };
    client.interceptors.add(getIt<AppInterceptors>());
    client.interceptors.add(getIt<PrettyDioLogger>());
  }

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (error) {
      return _handleDioException(error);
    }
  }

  @override
  Future<dynamic> post(String path,
      {Map<String, dynamic>? body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.post(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? FormData.fromMap(body!) : body);
      return response.data;
    } on DioException catch (error) {
      return _handleDioException(error);
    }
  }

  @override
  Future<dynamic> put(String path,
      {Map<String, dynamic>? body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.put(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? FormData.fromMap(body!) : body);
      return response.data;
    } on DioException catch (error) {
      return _handleDioException(error);
    }
  }

  @override
  Future<dynamic> patch(String path,
      {bool formDataIsEnabled = false,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.patch(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? FormData.fromMap(body!) : body);
      return response.data;
    } on DioException catch (error) {
      return _handleDioException(error);
    }
  }

  @override
  Future delete(
    String path, {
    bool formDataIsEnabled = false,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.delete(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? FormData.fromMap(body!) : body);
      return response;
    } on DioException catch (error) {
      return _handleDioException(error);
    }
  }

  // dynamic _handleResponseAsJson(Response<dynamic> response) {
  //   final responseJson = jsonDecode(response.data.toString());
  //   return responseJson;
  // }

  // dynamic _handleResponse(Response<dynamic> response) {
  //   if (response.statusCode == StatusCode.ok || response.statusCode == StatusCode.created) {
  //     return _handleResponseAsJson(response);
  //   } else if (response.statusCode == StatusCode.noResponse) {
  //     return {'message': 'Success with no response'};
  //   } else {
  //     throw ServerException.fromResponse(response.statusCode!, response.data);
  //   }
  // }

  dynamic _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        throw const ServerException('Connection Timeout');
      case DioExceptionType.sendTimeout:
        throw const ServerException('Send Timeout');
      case DioExceptionType.receiveTimeout:
        throw const ServerException('Receive Timeout');
      case DioExceptionType.badCertificate:
        throw const ServerException('Bad Certificate');
      case DioExceptionType.badResponse:
        throw ServerException.fromResponse(error.response!.statusCode!, error.response!.data);
      case DioExceptionType.cancel:
        throw const ServerException('Request Canceled');
      case DioExceptionType.connectionError:
        throw const ServerException('No Internet Connection');
      case DioExceptionType.unknown:
        throw const ServerException('There was an error, Try again!');
    }
  }
}
