import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class DeleteFromCart {
  DeleteFromCart();

  Future<(bool success, String message)> deleteFromCart(
      String storeEmail, String userEmail, String menuItemId) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Cart/delete'
          : 'http://10.0.2.2:7094/api/Cart/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'storeEmail': storeEmail,
        'userEmail': userEmail,
        'menuItemId': menuItemId
      }),
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log('Item successfully deleted from cart');
      return (true, response.body);
    } else {
      log('Error');
      log(response.body);
      return (false, response.body);
    }
  }
}
