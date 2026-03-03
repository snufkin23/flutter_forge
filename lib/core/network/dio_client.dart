import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

///  Wrapper for REST calls
///
@lazySingleton
class DioClient {
  final Dio _dio;

  DioClient(this._dio);

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) =>
      _dio.get(path, queryParameters: queryParams);

  Future<Response> post(String path, {dynamic data}) => _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) => _dio.put(path, data: data);

  Future<Response> delete(String path) => _dio.delete(path);
}
