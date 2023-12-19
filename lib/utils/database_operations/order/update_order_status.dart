import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/update_access_token.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateOrderStatusApi {
  UpdateOrderStatusApi();

  Future<(bool success, String message)> updateOrderStatusStore(
    BuildContext context,
    String orderId,
    int orderStatus,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final prefs = await SharedPreferences.getInstance();
    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Order/update-status'
          : 'http://10.0.2.2:7094/api/Order/update-status'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          <Object, Object>{'orderId': orderId, 'orderStatus': orderStatus}),
    );

    if (response.statusCode == 200) {
      log('Order status successfully updated');

      return (true, response.body);
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
              builder: (context) => LoginPage(isSwitched: false),
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
        UpdateOrderStatusApi()
            .updateOrderStatusStore(context, orderId, orderStatus);
      }
      return (false, response.body);
    } else {
      if (context.mounted) {
        _showErrorDialog(context, response.body);
      }
      log('Error update order');

      return (false, response.body);
    }
  }
}

Future<void> _showErrorDialog(context, String response) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
