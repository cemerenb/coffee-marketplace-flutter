import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
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
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://192.168.1.38:7094/api/UserPoints/update'
          : 'http://192.168.1.38:7094/api/UserPoints/update'),
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
