import 'package:shared_preferences/shared_preferences.dart';

Future<String> getUserData(int selection) async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');

  if (email == null) {
    return 'null';
  }
  if (selection == 0) {
    return email;
  } else {
    return 'No data found';
  }
}
