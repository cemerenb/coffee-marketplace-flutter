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

Future<(bool, String)> addToCart(
    BuildContext context, String storeEmail, String menuItemId) async {
  final String token = await getToken();

  // Your data to be sent as JSON
  final Map<String, dynamic> data = {
    'id': 0,
    'storeEmail': storeEmail,
    'accessToken': token,
    'menuItemId': menuItemId,
  };

  // Convert the data to JSON
  final String jsonData = jsonEncode(data);

  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final prefs = await SharedPreferences.getInstance();
    // Make a POST request to the API
    final http.Response response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Cart/add'
          : 'http://10.0.2.2:7094/api/Cart/add'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      log('Data sent successfully');
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
        addToCart(context, storeEmail, menuItemId);
      }
      return (false, response.body);
    } else {
      log('Failed to send data. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
      return (false, response.body);
    }
  } catch (e) {
    log('Error sending data: $e');
    return (false, e.toString());
  }
}
