import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

///  Wrapper for REST calls
///
@lazySingleton
class DioClient {
  DioClient(this._dio);
  final Dio _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) =>
      _dio.get(path, queryParameters: queryParams);

  Future<Response<dynamic>> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response<dynamic>> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);

  Future<Response<dynamic>> delete(String path) => _dio.delete(path);
}
