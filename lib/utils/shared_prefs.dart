import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return (prefs.getString('accessToken') ?? '');
  }

  static Future<String> getPrefsData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return (prefs.getString(key) ?? '');
  }

  static Future<void> setPrefsData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}
