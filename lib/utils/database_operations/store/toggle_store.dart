import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToggleStoreStatus {
  ToggleStoreStatus();

  Future<(bool success, String message)> toggleStoreStatus(
    BuildContext context,
    String storeEmail,
    int storeIsOn,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://192.168.1.38:7094/api/Store/toggle-store'
          : 'http://192.168.1.38:7094/api/Store/toggle-store'),
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
