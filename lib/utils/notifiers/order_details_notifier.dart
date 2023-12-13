import 'dart:convert';
import 'dart:developer';

import 'package:coffee/utils/classes/order_details_class.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderDetailsNotifier extends ChangeNotifier {
  List<OrderDetails> orderDetails = [];

  Future<void> fetchOrderDetailsData() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
      final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://192.168.1.38:7094/api/OrderDetails/get-order-details'
          : 'http://192.168.1.38:7094/api/OrderDetails/get-order-details'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        orderDetails = (data as List).map((orderData) {
          return OrderDetails(
            storeEmail: orderData['storeEmail'],
            orderId: orderData['orderId'],
            userEmail: orderData['userEmail'],
            menuItemId: orderData['menuItemId'],
            itemCount: orderData['itemCount'],
            itemCanceled: orderData['itemCanceled'],
            cancelNote: orderData['cancelNote'],
          );
        }).toList();

        log("order details lenght: ${orderDetails.length.toString()}");
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
