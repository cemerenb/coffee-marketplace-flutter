import 'package:coffee/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logOut(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', "");
  await prefs.setString('password', "");
  await prefs.setString('accountType', "");
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(isSwitched: false),
      ),
      (route) => false);
}
