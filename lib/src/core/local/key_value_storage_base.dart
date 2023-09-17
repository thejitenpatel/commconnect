import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base class containing a unified API for key-value pairs' storage.
/// This class provides low level methods for storing:
/// - Sensitive keys using [FlutterSecureStorage]
/// - Insensitive keys using [SharedPreferences]
class KeyValueStorageBase {
  /// Instance of shared preferences
  static SharedPreferences? _sharedPrefs;

  /// Instance of flutter secure storage
  static FlutterSecureStorage? _secureStorage;

  /// Singleton instance of KeyValueStorage Helper
  static KeyValueStorageBase? _instance;

  factory KeyValueStorageBase() => _instance ?? const KeyValueStorageBase._();

  /// Private constructor
  const KeyValueStorageBase._();

  static Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  /// Reads the value for the key from common preferences storage
  T? getCommon<T>(String key) {
    try {
      switch (T) {
        case String:
          return _sharedPrefs!.getString(key) as T?;
        case int:
          return _sharedPrefs!.getInt(key) as T?;
        case bool:
          return _sharedPrefs!.getBool(key) as T?;
        case double:
          return _sharedPrefs!.getDouble(key) as T?;
        default:
          return _sharedPrefs!.get(key) as T?;
      }
    } on Exception catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  /// Sets the value for the key to common preferences storage
  Future<bool> setCommon<T>(String key, T value) {
    switch (T) {
      case String:
        return _sharedPrefs!.setString(key, value as String);
      case int:
        return _sharedPrefs!.setInt(key, value as int);
      case bool:
        return _sharedPrefs!.setBool(key, value as bool);
      case double:
        return _sharedPrefs!.setDouble(key, value as double);
      default:
        return _sharedPrefs!.setString(key, value as String);
    }
  }

  /// Reads the decrypted value for the key from secure storage
  Future<String?> getEncrypted(String key) {
    try {
      return _secureStorage!.read(key: key);
    } on PlatformException catch (e) {
      debugPrint('$e');
      return Future<String?>.value();
    }
  }

  /// Sets the encrypted value for the key to secure storage
  Future<bool> setEncrypted(String key, String value) {
    try {
      _secureStorage!.write(key: key, value: value);
      return Future.value(true);
    } on PlatformException catch (e) {
      debugPrint('$e');
      return Future.value(false);
    }
  }

  /// Erases common preferences keys
  Future<bool> clearCommon() => _sharedPrefs!.clear();

  /// Erases encrypted keys
  Future<bool> clearEncrypted() async {
    try {
      await _secureStorage!.deleteAll();
      return true;
    } on PlatformException catch (e) {
      debugPrint('$e');
      return false;
    }
  }
}
