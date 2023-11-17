import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../classes/cart_class.dart';
import '../get_user/get_user_data.dart';
import 'package:http/http.dart' as http;

class CartNotifier extends ChangeNotifier {
  List<Cart> cart = [];

  Future<void> getCart() async {
    String email = await getUserData(0);
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.0.28:7094/api/Cart/get-all?UserEmail=$email'));

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
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      notifyListeners();
    }
  }
}
