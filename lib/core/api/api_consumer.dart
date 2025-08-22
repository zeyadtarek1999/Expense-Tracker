abstract class ApiConsumer {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool formDataIsEnabled,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> put(
    String path, {
    bool formDataIsEnabled,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> patch(
    String path, {
    bool formDataIsEnabled,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> delete(
    String path, {
    bool formDataIsEnabled,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });
}
