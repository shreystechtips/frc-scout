import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  SharedPreferences prefs;
  AppData._(this.prefs);
  static Future<AppData> create() async {
    return AppData._(await SharedPreferences.getInstance());
  }

  String getString(String key) => prefs.getString(key) ?? '';
  int getInt(String key) => prefs.getInt(key) ?? 0;
  double getDouble(String key) => prefs.getDouble(key) ?? 0.0;
  bool getBool(String key) => prefs.getBool(key) ?? false;

  void setString(String key, String value) => prefs.setString(key, value);
  void setInt(String key, int value) => prefs.setInt(key, value);
  void setDouble(String key, double value) => prefs.setDouble(key, value);
  void setBool(String key, bool value) => prefs.setBool(key, value);
}
