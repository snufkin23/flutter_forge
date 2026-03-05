import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await _getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final String newToken = await _refreshToken();

        // Retry original request with new token
        final RequestOptions opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';

        final Response<dynamic> response = await Dio().fetch<dynamic>(opts);
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
