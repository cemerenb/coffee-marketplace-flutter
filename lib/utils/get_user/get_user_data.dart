import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

Future<String> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');

  if (email == null) {
    return 'null';
  } else {
    log(email);
    return email;
  }
}
