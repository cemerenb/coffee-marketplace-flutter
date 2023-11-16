import 'dart:convert';
import 'dart:developer';
import 'package:coffee/utils/classes/cart_class.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';

import 'package:http/http.dart' as http;

import '../../../pages/customer_pages/customer_list_stores.dart';

Future<(bool, int)> getCart(String itemId) async {
  String email = await getUserData(0);
  try {
    final response = await http.get(Uri.parse(
        'http://192.168.0.28:7094/api/Cart/get-all?UserEmail=$email'));

    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      final data = json.decode(response.body);

      cart = (data as List).map((cartData) {
        if (cartData['menuItemId'] == itemId) {
          return Cart(
              storeEmail: cartData['storeEmail'],
              userEmail: cartData['userEmail'],
              menuItemId: cartData['menuItemId'],
              itemCount: cartData['itemCount']);
        } else {
          return Cart(
              storeEmail: "", userEmail: "", menuItemId: "", itemCount: -1);
        }
      }).toList();
      return (true, cart[0].itemCount);
    } else {
      log('Error: ${response.statusCode}');
      return (false, -1);
    }
  } catch (e) {
    log('Error: $e');
    return (false, -1);
  }
}
