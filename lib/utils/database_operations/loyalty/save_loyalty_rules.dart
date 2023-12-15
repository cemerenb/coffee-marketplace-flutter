import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SetLoyaltyRules {
  // Your API base URL

  SetLoyaltyRules();

  Future<(bool success, String message)> setRules(
    BuildContext context,
    int isPointsEnabled,
    String storeEmail,
    int pointsToGain,
    int category1Gain,
    int category2Gain,
    int category3Gain,
    int category4Gain,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/PointRules/add-point-rule'
          : 'http://10.0.2.2:7094/api/PointRules/add-point-rule'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'isPointsEnabled': isPointsEnabled,
        'storeEmail': storeEmail,
        'pointsToGain': pointsToGain,
        'category1Gain': category1Gain,
        'category2Gain': category2Gain,
        'category3Gain': category3Gain,
        'category4Gain': category4Gain,
      }),
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        _showErrorDialog(context, response.body);
      }
      return (true, response.body);
    } else {
      if (context.mounted) {
        _showErrorDialog(context, response.body);
      }
      log('Loyalty Error');
      log(response.body);
      return (false, response.body);
    }
  }
}

Future<void> _showErrorDialog(context, String response) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
