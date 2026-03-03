import 'package:dio/dio.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_forge/core/env/env.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Logger logger() => Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      lineLength: 80,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kDebugMode ? Level.trace : Level.off,
  );

  @lazySingleton
  BaseOptions baseOptions() => BaseOptions(
    baseUrl: Env.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    validateStatus: (status) => status != null && status < 500,
  );

  @lazySingleton
  Dio dio(
    BaseOptions options,
    AuthInterceptor auth,
    LoggingInterceptor logging,
    ErrorInterceptor error,
  ) => Dio(options)..interceptors.addAll([auth, logging, error]);

  @lazySingleton
  Client ferryClient(Dio dio) {
    final dioLink = DioLink(Env.graphqlUrl, client: dio);
    return Client(link: dioLink, cache: Cache());
  }
}
