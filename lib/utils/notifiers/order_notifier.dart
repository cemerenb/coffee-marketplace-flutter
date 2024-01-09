import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/get_user/get_token.dart';
import 'package:coffee/utils/update_access_token.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/order_class.dart';

class OrderNotifier extends ChangeNotifier {
  List<Order> order = [];

  Future<void> fetchOrderData(BuildContext context) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final prefs = await SharedPreferences.getInstance();

      final String token = await getToken();
      final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Order/get-user-orders?AccessToken=$token'
          : 'http://10.0.2.2:7094/api/Order/get-user-orders?AccessToken=$token'));

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
      }
      if (response.statusCode == 210 && context.mounted) {
        await Dialogs.showErrorDialog(
            context, "Session has expired please log in again");
        await prefs.remove('email');
        await prefs.remove('accessToken');
        await prefs.remove('accountType');
        await prefs.remove('refreshToken');
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(isSwitched: true),
              ),
              (route) => false);
        }
      }
      if (response.statusCode == 211 && context.mounted) {
        bool isCompleted = false;
        String response = "";
        (isCompleted, response) =
            await UpdateRefreshToken().updateRefreshToken(context);
        if (isCompleted) {
          await prefs.remove("accessToken");
          await prefs.setString("accessToken", response);
        }
        if (context.mounted) {
          fetchOrderData(context);
        }
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
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final String token = await getToken();
      log(token);
      final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Order/get-store-orders?AccessToken=$token'
          : 'http://10.0.2.2:7094/api/Order/get-store-orders?AccessToken=$token'));

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
