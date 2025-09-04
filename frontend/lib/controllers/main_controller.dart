import 'package:shared_preferences/shared_preferences.dart';

class MainController {

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}