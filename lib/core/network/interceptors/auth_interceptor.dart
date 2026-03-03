import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final newToken = await _refreshToken();

        // Retry original request with new token
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';

        final response = await Dio().fetch(opts);
        return handler.resolve(response);
      } catch (_) {
        // Refresh failed — force logout
        _onSessionExpired();
      }
    }

    handler.next(err);
  }

  Future<String?> _getToken() async {
    // e.g. return await secureStorage.read(key: 'access_token');
    return null;
  }

  Future<String> _refreshToken() async {
    // e.g. call refresh endpoint, save new token, return it
    throw UnimplementedError();
  }

  void _onSessionExpired() {
    // e.g. navigate to login, clear storage
  }
}
