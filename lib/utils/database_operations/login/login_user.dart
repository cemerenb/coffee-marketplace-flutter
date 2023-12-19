import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../classes/stores.dart';
import '../../notifiers/order_notifier.dart';
import '../../notifiers/store_notifier.dart';

class LoginApi {
  LoginApi();
  List<Store> stores = [];
  Position? currentPosition;
  bool isCompleted = false;
  Future<bool> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position position) {
      currentPosition = position;
    }).catchError((e) {
      log(e.toString());
    });
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (context.mounted) {
      await context.read<StoreNotifier>().fetchStoreUserData();
    }
    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/User/login'
          : 'http://10.0.2.2:7094/api/User/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 && context.mounted) {
      log('Successfully login ${response.body}');
      context.read<OrderNotifier>().fetchOrderData(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', response.body.split("-").first);
      await prefs.setString('refreshToken', response.body.split("-").last);
      await prefs.setString('accountType', 'customer');
      await prefs.setString('email', email);
      if (context.mounted) {
        emailController.text = "";
        passwordController.text = "";
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const StoresListView(),
            ),
            (route) => false);
      }

      return true;
    } else if (response.statusCode != 200 && context.mounted) {
      _showErrorDialog(context, response.statusCode.toString());
    }

    return false;
  }
}

Future<void> _showErrorDialog(context, String response) async {
  if (response == "400") {
    response = "Email or password wrong";
  }
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  response,
                  style: const TextStyle(fontSize: 20),
                ),
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
