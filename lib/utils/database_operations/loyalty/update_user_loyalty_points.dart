import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateUserPoint {
  UpdateUserPoint();

  Future<(bool success, String message)> updateUserPoint(
      BuildContext context,
      String userEmail,
      String storeEmail,
      int totalPoint,
      int totalGained) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:7094/api/UserPoints/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'userEmail': userEmail,
        'storeEmail': storeEmail,
        'totalPoint': totalPoint,
        'totalGained': totalGained
      }),
    );

    if (response.statusCode == 200) {
      log('User point updated successfully');

      return (true, response.body);
    } else {
      log('User Point Error');
      log(response.body);
      log(response.statusCode.toString());
      return (false, response.body);
    }
  }
}
