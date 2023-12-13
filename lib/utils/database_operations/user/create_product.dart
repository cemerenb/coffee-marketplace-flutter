import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class CreateProductApi {
  CreateProductApi();

  Future<(bool success, String message)> createProduct(
    String storeEmail,
    String menuItemName,
    String menuItemDescription,
    String menuItemImageLink,
    String menuItemId,
    int menuItemIsAvaliable,
    int menuItemPrice,
    int menuItemCategory,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://192.168.1.38:7094/api/Menu/create'
          : 'http://192.168.1.38:7094/api/Menu/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'storeEmail': storeEmail,
        'menuItemName': menuItemName,
        'menuItemId': menuItemId,
        'menuItemDescription': menuItemDescription,
        'menuItemImageLink': menuItemImageLink,
        'menuItemIsAvaliable': menuItemIsAvaliable,
        'menuItemPrice': menuItemPrice,
        'menuItemCategory': menuItemCategory,
      }),
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log('Item successfully added to menu');
      return (true, response.body);
    } else {
      log('Error');
      log(response.body);
      return (false, response.body);
    }
  }
}
