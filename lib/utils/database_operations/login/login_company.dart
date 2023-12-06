import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompanyLoginApi {
  CompanyLoginApi();
  bool isCompleted = false;
  Future<bool> loginCompany(
    BuildContext context,
    String email,
    String password,
  ) async {
    context.read<StoreNotifier>();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:7094/api/Store/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'storeEmail': email,
        'storePassword': password,
      }),
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200 && context.mounted) {
      log('Successfully login');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('email') == null &&
          prefs.getString('password') == null) {
        await prefs.setString('email', email);
        await prefs.setString(
          'password',
          password,
        );
        if (context.mounted) {
          emailController.text = "";
          passwordController.text = "";
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => OrdersListView(
                  email: email,
                ),
              ),
              (route) => false);
        }
      }
      return true;
    } else if (response.statusCode != 200 && context.mounted) {
      _showErrorDialog(context, response.body);
    }

    return false;
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
