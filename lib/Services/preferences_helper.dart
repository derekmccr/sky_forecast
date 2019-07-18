import 'package:preferences/preferences.dart';

class PreferencesHelper{
  setMetric(String val) async{
    await PrefService.init(prefix: "_pref");
    PrefService.setString("temp_metric", val);
  }

  setTheme(String val) async{
    await PrefService.init(prefix: "_pref");
    PrefService.setString("ui_theme", val);
  }
}
