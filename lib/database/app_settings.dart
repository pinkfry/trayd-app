import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTest {
  final String _user_full_name = "_user_full_name";
  final String _user_email = "_user_email";
  final String _user_number = "_user_number";
  final String _user_profile_pic = "_user_profile_pic";
  final String _user_token = "_user_token";

  Future<String> getUserFullName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_user_full_name) ?? null;
  }

  Future<bool> setUserFullName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_user_full_name, value);
  }
  Future<String> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_user_token) ?? null;
  }

  Future<bool> setUserToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_user_token, value);
  }

  Future<String> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_user_email) ?? null;
  }

  Future<bool> setUserEmail(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_user_email, value);
  }
  Future<String> getUserNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_user_number) ?? null;
  }

  Future<bool> setUserNumber(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_user_number, value);
  }
  Future<String> getUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_user_profile_pic) ?? null;
  }

  Future<bool> setUserProfile(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_user_profile_pic, value);
  }
}
