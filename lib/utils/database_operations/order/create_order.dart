import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateOrder {
  // Your API base URL

  CreateOrder();

  Future<(bool success, String message)> createOrder(
      BuildContext context,
      String storeEmail,
      String userEmail,
      String orderNote,
      String orderId,
      int itemCount,
      double orderTotalPrice) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://192.168.1.38:7094/api/Order/create-order'
          : 'http://192.168.1.38:7094/api/Order/create-order'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'storeEmail': storeEmail,
        'orderId': orderId,
        'userEmail': userEmail,
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
    } else {
      if (context.mounted) {
        _showErrorDialog(context, response.body);
      }
      log('Error');
      log(response.body);
      return (false, response.body);
    }
  }
}

Future<void> _showErrorDialog(context, String response) async {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
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
