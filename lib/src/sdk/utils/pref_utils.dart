import 'package:shared_preferences/shared_preferences.dart';
import '../constants/preference_keys.dart';

class PreferenceUtils {
  // Save Methods
  static Future<bool> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  static Future<bool> saveInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value);
  }

  static Future<bool> saveDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setDouble(key, value);
  }

  static Future<bool> saveBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  static Future<bool> saveStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(key, value);
  }

  // Get Methods
  static Future<String> getString(String key, {String defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<int> getInt(String key, {int defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? defaultValue;
  }

  static Future<double> getDouble(String key, {double defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? defaultValue;
  }

  static Future<bool> getBool(String key, {bool defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<List<String>> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  // Other Methods

  static Future<bool> contains(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static Future<bool> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return await prefs.remove(key);
    }
    return false;
  }

  static Future<bool> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  // Custom Save Methods
  // static void saveUser(User user) {
  //   if (user != null) {
  //     String s = json.encode(user.toJson());
  //     saveString(PreferenceKeys.USER, s);
  //     saveBool(PreferenceKeys.IS_USER_LOGGED_IN, true);
  //     saveString(PreferenceKeys.USER_ID, user.id ?? "");
  //   }
  // }

  static void saveAccessToken(String token) {
    if (token != null) {
      saveString(PreferenceKeys.ACCESS_TOKEN, token);
    }
  }

  static void saveDeviceToken(String deviceToken) {
    if (deviceToken != null) {
      saveString(PreferenceKeys.DEVICE_TOKEN, deviceToken);
    }
  }

  static void savePin(String pin) {
    if (pin != null && pin.isNotEmpty) {
      saveString(PreferenceKeys.PIN, pin);
    }
  }

  // Customer Get Methods
  // static Future<User> getUser() async {
  //   String s = await getString(PreferenceKeys.USER);
  //   if (s != null) {
  //     final user = User.fromJson(json.decode(s));
  //     return user;
  //   }
  //   return null;
  // }

  static Future<bool> isUserLoggedIn() async {
    return await getBool(PreferenceKeys.IS_USER_LOGGED_IN, defaultValue: false);
  }

  static Future<String> getAccessToken() async {
    if (await contains(PreferenceKeys.ACCESS_TOKEN)) {
      return await getString(PreferenceKeys.ACCESS_TOKEN);
    }
    return "";
  }

  static Future<String> getUserId() async {
    if (await contains(PreferenceKeys.USER_ID)) {
      return await getString(PreferenceKeys.USER_ID);
    }
    return "";
  }

  static Future<String> getDeviceToken() async {
    if (await contains(PreferenceKeys.DEVICE_TOKEN)) {
      return await getString(PreferenceKeys.DEVICE_TOKEN);
    }
    return "";
  }

  static Future<String> getPin() async {
    if (await contains(PreferenceKeys.PIN)) {
      return await getString(PreferenceKeys.PIN);
    }
    return null;
  }

  // Remove Methods

}
