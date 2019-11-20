// use singleton pattern for SecureStorage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storageInstance = new FlutterSecureStorage();

  static FlutterSecureStorage get instance {
    return _storageInstance;
  }

  SecureStorage._privateConstructor();

  static final SecureStorage _instance = SecureStorage._privateConstructor();

  factory SecureStorage() {
    return _instance;
  }
}