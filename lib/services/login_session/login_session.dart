
import 'package:shared_preferences/shared_preferences.dart';


class LoginSession {

  static Future<void> saveSessionData(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save session data (e.g., token)
    await prefs.setString('role', role);
    // You can save additional session data if needed
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check if the session data exists
    return prefs.containsKey('role');
  }

  static Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the role from session data
    return prefs.getString('role');
  }

  static Future<void> clearSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove the token
    await prefs.remove('role');
    // You can remove additional session data if needed
  }

}
