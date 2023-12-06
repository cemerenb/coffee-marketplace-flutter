import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateOrderDetails {
  CreateOrderDetails();

  Future<(bool success, String message)> createOrder(
    BuildContext context,
    String storeEmail,
    String userEmail,
    String orderId,
    String menuItemId,
    int itemCount,
  ) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:7094/api/OrderDetails/create-order-details'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'storeEmail': storeEmail,
        'orderId': orderId,
        'userEmail': userEmail,
        'menuItemId': menuItemId,
        'itemCount': itemCount,
      }),
    );

    if (response.statusCode == 200) {
      log('Order details details succesfully placed');

      return (true, response.body);
    } else {
      if (context.mounted) {
        _showErrorDialog(context, response.body);
      }
      log('Error');
      log(response.body);
      return (false, response.body);
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
