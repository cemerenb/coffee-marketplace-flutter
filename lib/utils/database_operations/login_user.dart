import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_home_page.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  LoginApi();
  bool isCompleted = false;
  Future<bool> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('https://192.168.0.28:7094/api/User/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 && context.mounted) {
      log('Successfully login');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      if (context.mounted) {
        emailController.text = "";
        passwordController.text = "";
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const CompanyHomePage(),
            ),
            (route) => false);
      }

      return true;
    } else {
      _showErrorDialog(context, response.statusCode.toString());
    }

    return false;
  }
}

Future<void> _showErrorDialog(context, String response) async {
  if (response == "400") {
    response = "Email or password wrong";
  }
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  response,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
