import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateOrderStatusApi {
  UpdateOrderStatusApi();

  Future<(bool success, String message)> updateOrderStatusStore(
    BuildContext context,
    String orderId,
    int orderStatus,
  ) async {
    final response = await http.put(
      Uri.parse('http://192.168.0.28:7094/api/Order/update-status'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          <Object, Object>{'orderId': orderId, 'orderStatus': orderStatus}),
    );

    if (response.statusCode == 200) {
      log('Order status successfully updated');

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
