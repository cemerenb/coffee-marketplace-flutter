import 'dart:convert';
import 'dart:developer';

import 'package:coffee/utils/classes/loyalty_user_class.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoyaltyUserNotifier extends ChangeNotifier {
  List<LoyaltyUserRules> userPoints = [];

  Future<void> getPoints() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
      final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/UserPoints/get-all'
          : 'http://10.0.2.2:7094/api/UserPoints/get-all'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        userPoints = (data as List).map((pointData) {
          return LoyaltyUserRules(
            userEmail: pointData['userEmail'],
            storeEmail: pointData['storeEmail'],
            totalPoint: pointData['totalPoint'],
            totalGained: pointData['totalGained'],
          );
        }).toList();
        notifyListeners();
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      notifyListeners();
    }
  }
}
