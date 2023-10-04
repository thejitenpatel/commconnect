import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_storage_manager.g.dart';

@riverpod
LocalStorageManager localStorageManager(LocalStorageManagerRef ref) {
  return LocalStorageManager(boxName: "commConnect");
}

class LocalStorageManager {
  late Box _box;

  LocalStorageManager({required String boxName}) {
    Hive.box(boxName);
  }

  Future<void> initHive() async {
    await Hive.initFlutter();
  }

  Future<void> createBox(String boxName) async {
    await Hive.openBox(boxName);
  }

  Future<void> add(String key, dynamic value) async {
    await _box.put(key, value);
  }

  Future<dynamic> get(String key) async {
    return await _box.get(key);
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  bool containsKey(String key) {
    return _box.containsKey(key);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
