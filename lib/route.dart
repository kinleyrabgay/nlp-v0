// User direction (if firstTime -> Splash else dashboard)
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isFirstTimeUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  return isFirstTime;
}
