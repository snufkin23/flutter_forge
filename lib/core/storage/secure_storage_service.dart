import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          iOptions:
              IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );
  final FlutterSecureStorage _storage;

  Future<void> write({required String key, required String value}) async =>
      _storage.write(key: key, value: value);

  Future<String?> read({required String key}) async => _storage.read(key: key);

  Future<void> delete({required String key}) async => _storage.delete(key: key);

  Future<void> deleteAll() async => _storage.deleteAll();
}
