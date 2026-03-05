import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);
  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i(
      '→ REQUEST\n'
      '  Method  : ${options.method}\n'
      '  URL     : ${options.uri}\n'
      '  Headers : ${options.headers}\n'
      '  Body    : ${options.data ?? 'none'}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.d(
      '← RESPONSE\n'
      '  Status  : ${response.statusCode}\n'
      '  URL     : ${response.requestOptions.uri}\n'
      '  Data    : ${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '✗ ERROR\n'
      '  Status  : ${err.response?.statusCode}\n'
      '  URL     : ${err.requestOptions.uri}\n'
      '  Message : ${err.message}\n'
      '  Response: ${err.response?.data}',
      error: err,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }
}
