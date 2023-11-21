import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateStoreApi {
  UpdateStoreApi();

  Future<(bool success, String message)> updateStore(
    BuildContext context,
    String storeEmail,
    String storeOpeningTime,
    String storeClosingTime,
    String storeLogoLink,
    String storeCoverImageLink,
  ) async {
    final response = await http.put(
      Uri.parse('http://192.168.0.28:7094/api/Store/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'storeEmail': storeEmail,
        'storeLogoLink': storeLogoLink,
        'storeOpeningTime': storeOpeningTime,
        'storeClosingTime': storeClosingTime,
        'storeCoverImageLink': storeCoverImageLink,
      }),
    );

    if (response.statusCode == 200) {
      log('Store successfully updated');
      if (context.mounted) {
        _showCompletedDialog(context, response.body);
      }
      return (true, response.body);
    } else {
      if (context.mounted) {
        _showErrorDialog(context, response.body);
      }
      log('Error');
      log(response.body);
      log(response.statusCode.toString());
      return (false, response.body);
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
              onPressed: () async {
                final String email = await getUserData(0);
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrdersListView(
                                email: email,
                              )),
                      (route) => false);
                }
              },
            ),
          ],
        );
      });
}
