import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CancelOrderItem {
  CancelOrderItem();

  Future<(bool success, String message)> cancelOrderItem(
    BuildContext context,
    String storeEmail,
    String menuItemId,
    String orderId,
    int itemCanceled,
    String cancelNote,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/OrderDetails/cancel-order-item'
          : 'http://10.0.2.2:7094/api/OrderDetails/cancel-order-item'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'storeEmail': storeEmail,
        'menuItemId': menuItemId,
        'orderId': orderId,
        'itemCanceled': itemCanceled,
        'cancelNote': cancelNote,
      }),
    );

    if (response.statusCode == 200) {
      log('Store successfully updated');

      return (true, response.body);
    } else {
      log('Error');
      log(response.body);
      log(response.statusCode.toString());
      return (false, response.body);
    }
  }
}
