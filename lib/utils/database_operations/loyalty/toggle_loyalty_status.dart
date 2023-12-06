import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToggleLoyaltyStatus {
  ToggleLoyaltyStatus();

  Future<(bool success, String message)> toggleLoyaltyStatus(
    BuildContext context,
    String storeEmail,
    int isPointsEnabled,
  ) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:7094/api/PointRules/toggle-loyalty-status'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'storeEmail': storeEmail,
        'isPointsEnabled': isPointsEnabled,
      }),
    );
    if (response.statusCode == 200) {
      return (true, response.body);
    } else {
      return (false, response.body);
    }
  }
}
