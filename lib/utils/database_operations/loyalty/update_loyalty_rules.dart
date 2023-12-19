import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/get_user/get_token.dart';
import 'package:coffee/utils/update_access_token.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateLoyaltyRules {
  // Your API base URL

  UpdateLoyaltyRules();

  Future<(bool success, String message)> updateRules(
    BuildContext context,
    int isPointsEnabled,
    int pointsToGain,
    int category1Gain,
    int category2Gain,
    int category3Gain,
    int category4Gain,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final prefs = await SharedPreferences.getInstance();
    final String token = await getToken();
    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/PointRules/update'
          : 'http://10.0.2.2:7094/api/PointRules/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'isPointsEnabled': isPointsEnabled,
        'accessToken': token,
        'pointsToGain': pointsToGain,
        'category1Gain': category1Gain,
        'category2Gain': category2Gain,
        'category3Gain': category3Gain,
        'category4Gain': category4Gain,
      }),
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        Dialogs.showErrorDialog(context, response.body);
      }
      return (true, response.body);
    } else if (response.statusCode == 210 && context.mounted) {
      await Dialogs.showErrorDialog(
          context, "Session has expired please log in again");
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('accessToken');
      await prefs.remove('accountType');
      await prefs.remove('refreshToken');
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(isSwitched: true),
            ),
            (route) => false);
      }
      return (false, response.body);
    }
    if (response.statusCode == 211 && context.mounted) {
      bool isCompleted = false;
      String token = "";
      (isCompleted, token) =
          await UpdateRefreshToken().updateRefreshToken(context);
      if (isCompleted) {
        await prefs.remove("accessToken");
        await prefs.setString("accessToken", token);
      }
      if (context.mounted) {
        UpdateLoyaltyRules().updateRules(context, isPointsEnabled, pointsToGain,
            category1Gain, category2Gain, category3Gain, category4Gain);
      }
      return (false, response.body);
    } else {
      if (context.mounted) {
        Dialogs.showErrorDialog(context, response.body);
      }
      log('Loyalty Error');
      log(response.body);
      return (false, response.body);
    }
  }
}
