import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateUserLoyalty {
  CreateUserLoyalty();

  Future<bool> createUserLoyalty(
    BuildContext context,
    String userEmail,
    String storeEmail,
    int totalPoint,
    int totalGained,
  ) async {
    log(storeEmail);
    log(userEmail);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");

    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://192.168.1.38:7094/api/UserPoints/create-user-point'
          : 'http://192.168.1.38:7094/api/UserPoints/create-user-point'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'userEmail': userEmail,
        'storeEmail': storeEmail,
        'totalPoint': totalPoint,
        'totalGained': totalGained,
      }),
    );

    if (response.statusCode == 200) {
      log('User loyalty successfully registered');

      return true;
    } else {
      log('Error');
      log(response.body);
      return false;
    }
  }
}
