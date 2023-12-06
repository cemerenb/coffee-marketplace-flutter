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
    String menuItemId,
    int menuItemIsAvaliable,
    int menuItemPrice,
    int menuItemCategory,
  ) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:7094/api/Menu/create'),
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
