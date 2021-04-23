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

  Future<List<String>> getListPrefs(String listname, {prefs}) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    List<String> list = prefs.getStringList(listname);
    return (list != null) ? list : [];
  }

  addListPrefs(String listname, String value) async {
    var prefs = await SharedPreferences.getInstance();
    List<String> list = await this.getListPrefs(listname, prefs: prefs);
    list.add(value);
    prefs.setStringList(listname, list);
  }
}
