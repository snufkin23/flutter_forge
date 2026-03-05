import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
abstract class AppException with _$AppException implements Exception {
  // Local / Cache
  const factory AppException.cache({required String message}) = CacheException;

  // Validation / Input
  const factory AppException.validation({
    required String message,
    Map<String, String>? fieldErrors,
  }) = ValidationException;

  // Auth / Session (app-level, not HTTP)
  const factory AppException.unauthenticated({
    @Default('Session expired. Please login again.') String message,
  }) = UnauthenticatedException;

  // Navigation / Route
  const factory AppException.navigation({required String message}) =
      NavigationException;

  // Permission (device-level e.g. camera, location)
  const factory AppException.permission({required String message}) =
      PermissionException;

  // Unknown
  const factory AppException.unknown({
    @Default('An unexpected error occurred.') String message,
  }) = UnknownAppException;
}

extension AppExceptionX on AppException {
  String get readableMessage => when(
        cache: (String message) => message,
        validation: (String message, _) => message,
        unauthenticated: (String message) => message,
        navigation: (String message) => message,
        permission: (String message) => message,
        unknown: (String message) => message,
      );

  bool get isCache => this is CacheException;
  bool get isValidation => this is ValidationException;
  bool get isUnauthenticated => this is UnauthenticatedException;
  bool get isNavigation => this is NavigationException;
  bool get isPermission => this is PermissionException;
  bool get isUnknown => this is UnknownAppException;
}
