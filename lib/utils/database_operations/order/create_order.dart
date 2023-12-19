import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/get_user/get_token.dart';
import 'package:coffee/utils/update_access_token.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateOrder {
  // Your API base URL

  CreateOrder();

  Future<(bool success, String message)> createOrder(
      BuildContext context,
      String storeEmail,
      String orderNote,
      String orderId,
      int itemCount,
      double orderTotalPrice) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final prefs = await SharedPreferences.getInstance();
    final String token = await getToken();
    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Order/create-order'
          : 'http://10.0.2.2:7094/api/Order/create-order'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'storeEmail': storeEmail,
        'orderId': orderId,
        'accessToken': token,
        'orderStatus': 1,
        'orderNote': orderNote,
        'orderCreatingTime':
            "${DateTime.now().day < 10 ? "0${DateTime.now().day}" : "${DateTime.now().day}"} ${DateTime.now().month < 10 ? "0${DateTime.now().month}" : "${DateTime.now().month}"} ${DateTime.now().year}t${(DateTime.now().hour + 3) % 24 < 9 ? "0${(DateTime.now().hour + 3) % 24}" : "${(DateTime.now().hour + 3) % 24}"}:${DateTime.now().minute < 9 ? "0${DateTime.now().minute}" : "${DateTime.now().minute}"}",
        'itemCount': itemCount,
        'orderTotalPrice': orderTotalPrice,
      }),
    );

    if (response.statusCode == 200) {
      log('Order succesfully placed');
      if (context.mounted) {
        _showCompletedDialog(context, response.body);
      }
      return (true, response.body);
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
        CreateOrder().createOrder(context, storeEmail, orderNote, orderId,
            itemCount, orderTotalPrice);
      }
      return (false, response.body);
    } else {
      if (context.mounted) {
        Dialogs.showErrorDialog(context, response.body);
      }
      log('Error');
      log(response.body);
      return (false, response.body);
    }
  }
}

Future<void> _showCompletedDialog(BuildContext context, String response) async {
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
              onPressed: () async {
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StoresListView(),
                      ),
                      (route) => false);
                }
              },
            ),
          ],
        );
      });
}
