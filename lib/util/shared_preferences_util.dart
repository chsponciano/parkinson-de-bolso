import 'package:shared_preferences/shared_preferences.dart';

mixin SharedPreferencesUtil {
  addPrefs(String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  getPrefs(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  
  removePrefs(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}