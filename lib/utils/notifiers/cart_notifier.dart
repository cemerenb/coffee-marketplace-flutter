import 'dart:convert';
import 'dart:developer';

import 'package:coffee/utils/get_user/get_token.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import '../classes/cart_class.dart';
import 'package:http/http.dart' as http;

class CartNotifier extends ChangeNotifier {
  List<Cart> cart = [];

  Future<void> getCart() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final String token = await getToken();

      final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Cart/get-all?AccessToken=$token'
          : 'http://10.0.2.2:7094/api/Cart/get-all?AccessToken=$token'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        cart = (data as List).map((cartData) {
          return Cart(
              storeEmail: cartData['storeEmail'],
              userEmail: cartData['userEmail'],
              menuItemId: cartData['menuItemId'],
              itemCount: cartData['itemCount']);
        }).toList();
        notifyListeners();
      } else {
        log('Error: ${response.statusCode}');
        cart.clear();
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      notifyListeners();
    }
  }
}
