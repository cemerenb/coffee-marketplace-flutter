import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToggleLoyaltyStatus {
  ToggleLoyaltyStatus();

  Future<(bool success, String message)> toggleLoyaltyStatus(
    BuildContext context,
    String storeEmail,
    int isPointsEnabled,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/PointRules/toggle-loyalty-status'
          : 'http://10.0.2.2:7094/api/PointRules/toggle-loyalty-status'),
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
