import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../../pages/company_pages/company_menu_page.dart';
import '../../classes/menu_class.dart';

Future<void> fetchMenuData() async {
  try {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:7094/api/Menu/get-all'));

    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      final data = json.decode(response.body);

      menus = (data as List).map((menuData) {
        return Menu(
          menuItemName: menuData['menuItemName'],
          menuItemDescription: menuData['menuItemDescription'],
          menuItemImageLink: menuData['menuItemImageLink'],
          storeEmail: menuData['storeEmail'],
          menuItemIsAvaliable: menuData['menuItemIsAvaliable'],
          menuItemPrice: menuData['menuItemPrice'],
          menuItemCategory: menuData['menuItemCategory'],
          menuItemId: menuData['menuItemId'],
        );
      }).toList();
    } else {
      log('Error: ${response.statusCode}');
    }
  } catch (e) {
    log('Error: $e');
  }
}
