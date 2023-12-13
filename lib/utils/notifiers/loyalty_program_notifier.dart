import 'dart:convert';
import 'dart:developer';

import 'package:coffee/utils/classes/loyalty_class.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoyaltyNotifier extends ChangeNotifier {
  List<LoyaltyRules> rules = [];

  Future<void> getRules() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
      final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://192.168.1.38:7094/api/PointRules/get-all'
          : 'http://192.168.1.38:7094/api/PointRules/get-all'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        rules = (data as List).map((rulesData) {
          return LoyaltyRules(
            isPointsEnabled: rulesData['isPointsEnabled'],
            storeEmail: rulesData['storeEmail'],
            pointsToGain: rulesData['pointsToGain'],
            category1Gain: rulesData['category1Gain'],
            category2Gain: rulesData['category2Gain'],
            category3Gain: rulesData['category3Gain'],
            category4Gain: rulesData['category4Gain'],
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
