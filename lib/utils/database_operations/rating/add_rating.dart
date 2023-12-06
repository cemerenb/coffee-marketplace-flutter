import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RatingCreationApi {
  RatingCreationApi();

  Future<bool> createRating(BuildContext context, String storeEmail,
      String userEmail, String orderId, int ratingPoint, String comment) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:7094/api/Rating/add-rating'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'ratingId': "",
        'storeEmail': storeEmail,
        'userEmail': userEmail,
        'orderId': orderId,
        'ratingPoint': ratingPoint,
        'comment': comment,
        'ratingDate':
            "${DateTime.now().day < 10 ? "0${DateTime.now().day}" : "${DateTime.now().day}"} ${DateTime.now().month < 10 ? "0${DateTime.now().month}" : "${DateTime.now().month}"} ${DateTime.now().year}t${(DateTime.now().hour + 3) % 24 < 9 ? "0${(DateTime.now().hour + 3) % 24}" : "${(DateTime.now().hour + 3) % 24}"}:${DateTime.now().minute < 9 ? "0${DateTime.now().minute}" : "${DateTime.now().minute}"}",
      }),
    );

    if (response.statusCode == 200) {
      log('Rating successfully created');
      if (context.mounted) {
        await _showErrorDialog(context, response.body);
      }
      return true;
    } else {
      if (context.mounted) {
        await _showErrorDialog(context, response.body);
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
