import 'package:shared_preferences/shared_preferences.dart';

Future<String> getUserData(int selection) async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  final password = prefs.getString('password');

  if (email == null) {
    return 'null';
  }
  if (selection == 0) {
    return email;
  }
  if (password != null && selection == 1) {
    return password;
  } else {
    return 'No data found';
  }
}
