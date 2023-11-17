import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../classes/menu_class.dart';

class MenuNotifier extends ChangeNotifier {
  List<Menu> menu = [];

  Future<void> fetchMenuUserData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.28:7094/api/Menu/get-all'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        menu = (data as List).map((menuData) {
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
        notifyListeners();
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      notifyListeners();
    }
  }
}