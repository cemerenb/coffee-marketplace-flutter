import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../classes/order_class.dart';

class OrderNotifier extends ChangeNotifier {
  List<Order> order = [];

  Future<void> fetchOrderData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.28:7094/api/Order/get-orders'));

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
}
