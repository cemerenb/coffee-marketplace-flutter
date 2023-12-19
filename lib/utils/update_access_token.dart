import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/get_user/get_refresh_token.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateRefreshToken {
  UpdateRefreshToken();

  Future<(bool success, String message)> updateRefreshToken(
    BuildContext context,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final String refreshToken = await getRefreshToken();

    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Token/update'
          : 'http://10.0.2.2:7094/api/Token/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      log('Token Updated');

      return (true, response.body);
    }
    if (response.statusCode == 210) {
      if (context.mounted) {
        await Dialogs.showErrorDialog(
            context, "Session has expired please log in again");
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(isSwitched: false),
              ),
              (route) => false);
        }
      }
      return (false, response.body);
    } else {
      log('Error while token update');
      return (false, response.body);
    }
  }
}
