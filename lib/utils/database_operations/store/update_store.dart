import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/get_user/get_token.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/update_access_token.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateStoreApi {
  UpdateStoreApi();

  Future<(bool success, String message)> updateStore(
      BuildContext context,
      String storeOpeningTime,
      String storeClosingTime,
      String storeLogoLink,
      String storeCoverImageLink,
      String latitude,
      String longitude) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final String token = await getToken();
    final prefs = await SharedPreferences.getInstance();
    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Store/update'
          : 'http://10.0.2.2:7094/api/Store/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'accessToken': token,
        'storeLogoLink': storeLogoLink,
        'storeOpeningTime': storeOpeningTime,
        'storeClosingTime': storeClosingTime,
        'storeCoverImageLink': storeCoverImageLink,
        'latitude': latitude,
        'longitude': longitude
      }),
    );

    if (response.statusCode == 200) {
      log('Store successfully updated');
      if (context.mounted) {
        _showCompletedDialog(context, response.body);
      }
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
        UpdateStoreApi().updateStore(
            context,
            storeOpeningTime,
            storeClosingTime,
            storeLogoLink,
            storeCoverImageLink,
            latitude,
            longitude);
      }
      return (false, response.body);
    } else {
      if (context.mounted) {
        Dialogs.showErrorDialog(context, response.body);
      }
      log('Error');
      log(response.body);
      log(response.statusCode.toString());
      return (false, response.body);
    }
  }
}

Future<void> _showCompletedDialog(BuildContext context, String response) async {
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
              onPressed: () async {
                final String email = await getUserData(0);
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrdersListView(
                                email: email,
                              )),
                      (route) => false);
                }
              },
            ),
          ],
        );
      });
}
