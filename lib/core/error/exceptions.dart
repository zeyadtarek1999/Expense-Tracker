import '../api/status_code.dart';

class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  factory ServerException.fromResponse(int statusCode, Map<String, dynamic> response) {
    String? errorMsg;

    switch (statusCode) {
      //400
      case StatusCode.badRequest:
        errorMsg = response['error']['errors'][0]['message'];
        throw ServerException(errorMsg!);
      //401
      case StatusCode.unauthorized:
        errorMsg = response['error']['errors'][0]['message'] ?? 'You Are Not Allowed!';
        throw ServerException(errorMsg!);
      //403
      case StatusCode.forbidden:
        errorMsg = response['error']['errors'][0]['message'] ?? 'Wrong Credentials!';
        throw ServerException(errorMsg!);
      //404
      case StatusCode.notFound:
        errorMsg = response['error']['errors'][0]['message'] ?? 'Not found!';
        throw ServerException(errorMsg!);
      //409
      case StatusCode.conflict:
        errorMsg = response['error']['errors'][0]['message'];
        throw ServerException(errorMsg!);
      //422
      case StatusCode.unProcessableEntity:
        var message = response['error']['errors'][0]['message'];
        if (message is Map) {
          errorMsg = message.values.toList().toString();
        } else {
          // errorMsg = message;
          errorMsg = message[0];
        }
        throw ServerException(errorMsg!);
      //500
      case StatusCode.internalServerError:
        throw ServerException(errorMsg!);

      default:
        throw const ServerException('Error, Try again!');
    }
  }

  @override
  String toString() {
    return message;
  }
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);

  @override
  String toString() {
    return message;
  }
}
