import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class DeleteFromCart {
  DeleteFromCart();

  Future<(bool success, String message)> deleteFromCart(
      String storeEmail, String userEmail, String menuItemId) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.28:7094/api/Cart/delete'),
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
