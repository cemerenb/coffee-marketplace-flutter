import 'dart:convert';
import 'dart:developer';

import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../classes/order_class.dart';

class OrderNotifier extends ChangeNotifier {
  List<Order> order = [];

  Future<void> fetchOrderData() async {
    final email = await getUserData(0);
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
      final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Order/get-user-orders?UserEmail=$email'
          : 'http://10.0.2.2:7094/api/Order/get-user-orders?UserEmail=$email'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        order = (data as List).map((orderData) {
          return Order(
            storeEmail: orderData['storeEmail'],
            orderId: orderData['orderId'],
            userEmail: orderData['userEmail'],
            orderStatus: orderData['orderStatus'],
            orderNote: orderData['orderNote'],
            orderCreatingTime: orderData['orderCreatingTime'],
            itemCount: orderData['itemCount'],
            orderTotalPrice: orderData['orderTotalPrice'],
          );
        }).toList();
      } else {
        log('Error: ${response.statusCode}');
        notifyListeners();
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCompanyOrderData() async {
    final email = await getUserData(0);
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
      final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Order/get-store-orders?StoreEmail=$email'
          : 'http://10.0.2.2:7094/api/Order/get-store-orders?StoreEmail=$email'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        order = (data as List).map((orderData) {
          return Order(
            storeEmail: orderData['storeEmail'],
            orderId: orderData['orderId'],
            userEmail: orderData['userEmail'],
            orderStatus: orderData['orderStatus'],
            orderNote: orderData['orderNote'],
            orderCreatingTime: orderData['orderCreatingTime'],
            itemCount: orderData['itemCount'],
            orderTotalPrice: orderData['orderTotalPrice'],
          );
        }).toList();
      } else {
        log('Error: ${response.statusCode}');
        notifyListeners();
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      notifyListeners();
    }
  }
}
