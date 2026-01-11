import 'dart:convert';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_getx_boilerplate/shared/enum/enum.dart';

class StorageService {
  static SharedPreferences? _sharedPreferences;

  static Future<SharedPreferences> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();

    return _sharedPreferences!;
  }

  /// Theme mode
  ///
  /// 0: System
  /// 1: Light
  /// 2: Dark
  static AppThemeMode get themeModeStorage => AppThemeMode.fromInt(
      _sharedPreferences?.getInt(StorageConstants.themeMode) ??
          AppThemeMode.light.index);

  static set themeModeStorage(AppThemeMode value) =>
      _sharedPreferences?.setInt(StorageConstants.themeMode, value.index);

  static String? get token =>
      _sharedPreferences?.getString(StorageConstants.token);
  static set token(String? value) =>
      _sharedPreferences?.setString(StorageConstants.token, value ?? '');

  static String? get refreshToken =>
      _sharedPreferences?.getString(StorageConstants.refreshToken);
  static set refreshToken(String? value) =>
      _sharedPreferences?.setString(StorageConstants.refreshToken, value ?? '');

  static bool get firstInstall =>
      _sharedPreferences?.getBool(StorageConstants.firstInstall) ?? true;
  static set firstInstall(bool value) =>
      _sharedPreferences?.setBool(StorageConstants.firstInstall, value);

  static String? get lang =>
      _sharedPreferences?.getString(StorageConstants.lang);
  static set lang(String? value) =>
      _sharedPreferences?.setString(StorageConstants.lang, value ?? '');

  static Map<String, dynamic>? get patientProfileData {
    final data =
        _sharedPreferences?.getString(StorageConstants.patientProfileData);
    if (data != null && data.isNotEmpty) {
      return json.decode(data);
    }
    return null;
  }

  static set patientProfileData(Map<String, dynamic>? value) =>
      _sharedPreferences?.setString(StorageConstants.patientProfileData,
          value != null ? json.encode(value) : '');

  static Map<String, dynamic>? get userData {
    final data = _sharedPreferences?.getString(StorageConstants.userInfo);
    if (data != null && data.isNotEmpty) {
      return json.decode(data);
    }
    return null;
  }

  static set userData(Map<String, dynamic>? value) =>
      _sharedPreferences?.setString(
          StorageConstants.userInfo, value != null ? json.encode(value) : '');

  static List<Map<String, dynamic>>? get vaccineCart {
    final data = _sharedPreferences?.getString(StorageConstants.vaccineCart);
    if (data != null && data.isNotEmpty) {
      final List<dynamic> decoded = json.decode(data);
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    }
    return null;
  }

  static set vaccineCart(List<Map<String, dynamic>>? value) =>
      _sharedPreferences?.setString(StorageConstants.vaccineCart,
          value != null ? json.encode(value) : '');

  /// more code
  /// --------- ------------ -------------

  /// Soft clean cache
  ///
  /// Call when logout
  static void clear() {
    _sharedPreferences?.remove(StorageConstants.token);
    _sharedPreferences?.remove(StorageConstants.refreshToken);
    _sharedPreferences?.remove(StorageConstants.userInfo);
    _sharedPreferences?.remove(StorageConstants.vaccineCart);

    /// more code
  }
}
