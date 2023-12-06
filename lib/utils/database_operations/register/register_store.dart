import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoreRegistrationApi {
  StoreRegistrationApi();

  Future<bool> registerStore(
      BuildContext context,
      String storeName,
      String taxId,
      String email,
      String password,
      String confirmPassword) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:7094/api/Store/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'storeName': storeName,
        'storeEmail': email,
        'storeTaxId': taxId,
        'storePassword': password,
        'storeConfirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      log('Successfully registered');
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
      barrierDismissible: false,
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
      barrierDismissible: false,
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
                        isSwitched: true,
                      ),
                    ),
                    (route) => false);
              },
            ),
          ],
        );
      });
}
