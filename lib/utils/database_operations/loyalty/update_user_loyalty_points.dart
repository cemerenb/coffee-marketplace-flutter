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

class UpdateUserPoint {
  UpdateUserPoint();

  Future<(bool success, String message)> updateUserPoint(BuildContext context,
      String userEmail, int totalPoint, int totalGained) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final prefs = await SharedPreferences.getInstance();

    final String token = await getToken();
    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/UserPoints/update'
          : 'http://10.0.2.2:7094/api/UserPoints/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'userEmail': userEmail,
        'accessToken': token,
        'totalPoint': totalPoint,
        'totalGained': totalGained
      }),
    );

    if (response.statusCode == 200) {
      log('User point updated successfully');

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
        UpdateUserPoint()
            .updateUserPoint(context, userEmail, totalPoint, totalGained);
      }
      return (false, response.body);
    } else {
      log('User Point Error');
      log(response.body);
      log(response.statusCode.toString());
      return (false, response.body);
    }
  }
}
