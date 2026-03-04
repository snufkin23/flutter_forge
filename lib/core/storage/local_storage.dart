import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:injectable/injectable.dart';

import 'storage_keys.dart';

@lazySingleton
class LocalStorage {
  late Box<dynamic> _appBox;

  Box<dynamic> get appBox => _appBox;
  @preResolve
  @factoryMethod
  static Future<LocalStorage> init() async {
    final LocalStorage service = LocalStorage();
    await service._init();
    return service;
  }

  Future<void> _init() async {
    await Hive.initFlutter();
    _appBox = await Hive.openBox(StorageKeys.appBox);
  }

  // Generic get
  T? get<T>(String key) => _appBox.get(key) as T?;

  // Generic put
  Future<void> put<T>(String key, T value) async => _appBox.put(key, value);

  // Delete
  Future<void> delete(String key) async => _appBox.delete(key);

  // Clear entire box
  Future<void> clearAll() async => _appBox.clear();
}
