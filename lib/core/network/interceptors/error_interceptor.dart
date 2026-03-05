import 'package:dio/dio.dart';
import 'package:flutter_forge/core/error/api_exception.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final ApiException exception = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const ApiException.timeout(),
      DioExceptionType.cancel =>
        const ApiException.unknown(message: 'Request was cancelled'),
      DioExceptionType.connectionError => const ApiException.network(
          message: 'No internet connection',
        ),
      DioExceptionType.badResponse => _fromStatusCode(err.response?.statusCode),
      _ => ApiException.unknown(message: err.message ?? 'Unexpected error'),
    };

    handler.next(err.copyWith(error: exception));
  }

  ApiException _fromStatusCode(int? code) => switch (code) {
        401 => const ApiException.unauthorized(),
        403 => const ApiException.forbidden(),
        404 => const ApiException.notFound(),
        final int status when status >= 500 => ApiException.server(
            message: 'Server error',
            statusCode: status,
          ),
        _ => ApiException.network(message: 'Request failed', statusCode: code),
      };
}
