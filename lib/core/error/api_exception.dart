import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';

@freezed
abstract class ApiException with _$ApiException implements Exception {
  /// 4xx/5xx or no response from server
  const factory ApiException.network({
    required String message,
    int? statusCode,
  }) = NetworkException;

  /// 500+ server error
  const factory ApiException.server({
    required String message,
    int? statusCode,
  }) = ServerException;

  /// 401
  const factory ApiException.unauthorized({
    @Default('Unauthorized. Please login again.') String message,
  }) = UnauthorizedException;

  /// 403
  const factory ApiException.forbidden({
    @Default('You do not have permission.') String message,
  }) = ForbiddenException;

  /// 404
  const factory ApiException.notFound({
    @Default('Resource not found.') String message,
  }) = NotFoundException;

  /// Request timed out
  const factory ApiException.timeout({
    @Default('Request timed out. Please try again.') String message,
  }) = TimeoutException;

  /// Any other unexpected API error
  const factory ApiException.unknown({
    @Default('An unexpected error occurred.') String message,
  }) = UnknownApiException;
}

extension ApiExceptionX on ApiException {
  String get readableMessage => when(
        network: (String message, _) => message,
        server: (String message, _) => message,
        unauthorized: (String message) => message,
        forbidden: (String message) => message,
        notFound: (String message) => message,
        timeout: (String message) => message,
        unknown: (String message) => message,
      );

  bool get isUnauthorized => this is UnauthorizedException;
  bool get isNetwork => this is NetworkException;
  bool get isServer => this is ServerException;
  bool get isTimeout => this is TimeoutException;
  bool get isNotFound => this is NotFoundException;
}
