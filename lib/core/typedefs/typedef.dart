import 'package:flutter_forge/core/error/api_exception.dart';
import 'package:flutter_forge/core/error/app_exception.dart';
import 'package:fpdart/fpdart.dart';

/// For remote/network calls — fails with [ApiException]
///
typedef ApiResponse<T> = Either<ApiException, T>;

/// For local/app-level calls — fails with [AppException]
///
typedef AppResponse<T> = Either<AppException, T>;

/// When a call can fail with either (e.g. repository that hits both)
///
typedef Response<T> = Either<Exception, T>;
