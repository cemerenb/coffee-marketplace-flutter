import 'package:shared_preferences/shared_preferences.dart';

Future<String> getRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('refreshToken');
  return token!.isNotEmpty ? token : "";
}
