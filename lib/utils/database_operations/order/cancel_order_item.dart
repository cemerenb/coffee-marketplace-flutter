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

class CancelOrderItem {
  CancelOrderItem();

  Future<(bool success, String message)> cancelOrderItem(
    BuildContext context,
    String menuItemId,
    String orderId,
    int itemCanceled,
    String cancelNote,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final prefs = await SharedPreferences.getInstance();
    final String token = await getToken();
    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/OrderDetails/cancel-order-item'
          : 'http://10.0.2.2:7094/api/OrderDetails/cancel-order-item'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'accessToken': token,
        'menuItemId': menuItemId,
        'orderId': orderId,
        'itemCanceled': itemCanceled,
        'cancelNote': cancelNote,
      }),
    );

    if (response.statusCode == 200) {
      log('Store successfully updated');

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
        CancelOrderItem().cancelOrderItem(
            context, menuItemId, orderId, itemCanceled, cancelNote);
      }
      return (false, response.body);
    } else {
      log('Error');
      log(response.body);
      log(response.statusCode.toString());
      return (false, response.body);
    }
  }
}
