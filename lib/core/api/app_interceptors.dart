 import 'package:dio/dio.dart';
import '../../injection_container.dart';
import '../app_constants/local_cache_keys.dart';
import '../helpers/shared_prefrences.dart';
import '../network/netwok_info.dart';

class AppInterceptors extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (await getIt<NetworkInfo>().isConnected) {
      String? token = getIt<CacheHelper>().getData(key: AppLocalCacheKey.token);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      super.onRequest(options, handler);
    } else {
      handler.next(options);
    }
  }
}
