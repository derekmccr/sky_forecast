import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String _userMetric = "metric";

  //getter & setter for user's preferred metric reading for temp
  Future<String> getUserMetric() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userMetric) ?? "F";
  }
  Future<bool> setUserMetric(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userMetric, value);
  }
}
