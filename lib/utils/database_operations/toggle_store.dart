import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToggleStoreStatus {
  ToggleStoreStatus();

  Future<(bool success, String message)> toggleStoreStatus(
    BuildContext context,
    String storeEmail,
    int storeIsOn,
  ) async {
    final response = await http.put(
      Uri.parse('http://192.168.0.28:7094/api/Store/toggle-store'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'storeEmail': storeEmail,
        'storeIsOn': storeIsOn,
      }),
    );
    if (response.statusCode == 200) {
      return (true, response.body);
    } else {
      return (false, response.body);
    }
  }
}
