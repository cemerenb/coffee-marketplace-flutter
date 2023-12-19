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

class UpdateCartApi {
  UpdateCartApi();

  Future<bool> updateCart(
      BuildContext context, String menuItemId, int itemCount) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = await getToken();

    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Cart/update'
          : 'http://10.0.2.2:7094/api/Cart/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'accessToken': token,
        'menuItemId': menuItemId,
        'itemCount': itemCount,
      }),
    );

    if (response.statusCode == 200) {
      log('Cart successfully updated');

      return true;
    }
    if (response.statusCode == 210 && context.mounted) {
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
      return false;
    }
    if (response.statusCode == 211 && context.mounted) {
      bool isCompleted = false;
      String response = "";
      (isCompleted, response) =
          await UpdateRefreshToken().updateRefreshToken(context);
      if (isCompleted) {
        await prefs.remove("accessToken");
        await prefs.setString("accessToken", response);
      }
      if (context.mounted) {
        UpdateCartApi().updateCart(context, menuItemId, itemCount);
      }
      return false;
    } else {
      log('Error');
      log(response.body);
      log(response.statusCode.toString());
      return false;
    }
  }
}
