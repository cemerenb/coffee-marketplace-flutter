import 'dart:convert';
import 'dart:developer';
import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/update_access_token.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateUserLoyalty {
  CreateUserLoyalty();

  Future<bool> createUserLoyalty(
    BuildContext context,
    String accessToken,
    String userEmail,
    int totalPoint,
    int totalGained,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/UserPoints/create-user-point'
          : 'http://10.0.2.2:7094/api/UserPoints/create-user-point'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'accessToken': accessToken,
        'userEmail': userEmail,
        'totalPoint': totalPoint,
        'totalGained': totalGained,
      }),
    );

    if (response.statusCode == 200) {
      log('User point data successfully created');

      return true;
    } else if (response.statusCode == 210 && context.mounted) {
      await Dialogs.showErrorDialog(
          context, "Session has expired please log in again");
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
      return false;
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
        CreateUserLoyalty().createUserLoyalty(
            context, accessToken, userEmail, totalPoint, totalGained);
      }
      return false;
    } else {
      log('Error');
      log(response.body);
      return false;
    }
  }
}
