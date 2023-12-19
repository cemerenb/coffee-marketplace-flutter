import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('accessToken');
  return token!.isNotEmpty ? token : "";
}
