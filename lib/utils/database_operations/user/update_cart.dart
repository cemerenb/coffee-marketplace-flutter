import 'dart:convert';
import 'dart:developer';

import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateCartApi {
  UpdateCartApi();

  Future<bool> updateCart(
      BuildContext context, String menuItemId, int itemCount) async {
    final String userEmail = await getUserData(0);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.put(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://192.168.1.38:7094/api/Cart/update'
          : 'http://192.168.1.38:7094/api/Cart/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'userEmail': userEmail,
        'menuItemId': menuItemId,
        'itemCount': itemCount,
      }),
    );

    if (response.statusCode == 200) {
      log('Cart successfully updated');

      return true;
    } else {
      log('Error');
      log(response.body);
      log(response.statusCode.toString());
      return false;
    }
  }
}
