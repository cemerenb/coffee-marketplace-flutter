import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationApi {
  // Your API base URL

  RegistrationApi();

  Future<bool> registerUser(
      BuildContext context,
      String userName,
      String fullname,
      String email,
      String password,
      String confirmPassword) async {
    final response = await http.post(
      Uri.parse(
          'https://192.168.0.28:7094/api/User/register'), // Replace with your registration API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'fullname': fullname,
        'userName': userName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      log('Succesfuly registered');
      if (context.mounted) {
        _showCompletedDialog(context, response.body);
      }
      return true;
    } else {
      if (context.mounted) {
        _showErrorDialog(context, response.body);
      }
      log('Error');
      log(response.body);
      return false;
    }
  }
}

Future<void> _showErrorDialog(context, String response) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(response),
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

Future<void> _showCompletedDialog(BuildContext context, String response) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(response),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        isSwitched: false,
                      ),
                    ),
                    (route) => false);
              },
            ),
          ],
        );
      });
}
