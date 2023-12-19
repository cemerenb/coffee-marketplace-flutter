import 'package:coffee/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logOut(context, bool isSwitched) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('email');
  await prefs.remove('accessToken');
  await prefs.remove('accountType');
  await prefs.remove('password');
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(isSwitched: isSwitched),
      ),
      (route) => false);
}
