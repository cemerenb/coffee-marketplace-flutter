import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class CreateProductApi {
  CreateProductApi();

  Future<(bool success, String message)> createProduct(
    String storeEmail,
    String menuItemName,
    String menuItemDescription,
    String menuItemImageLink,
    int menuItemIsAvaliable,
    int menuItemPrice,
    int menuItemCategory,
  ) async {
    final response = await http.post(
      Uri.parse('https://192.168.0.28:7094/api/Store/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'storeEmail': storeEmail,
        'menuItemName': menuItemName,
        'menuItemDescription': menuItemDescription,
        'menuItemImageLink': menuItemImageLink,
        'menuItemIsAvaliable': menuItemIsAvaliable,
        'menuItemPrice': menuItemPrice,
        'menuItemCategory': menuItemCategory,
      }),
    );

    if (response.statusCode == 200) {
      log('Successfully registered');
      return (true, response.body);
    } else {
      log('Error');
      log(response.body);
      return (false, response.body);
    }
  }
}
