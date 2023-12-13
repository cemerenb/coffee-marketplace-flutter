import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

import '../../get_user/get_user_data.dart';

Future<(bool, String)> addToCart(
    String storeEmail, String userEmail, String menuItemId) async {
  final String email = await getUserData(0);
  log('Cart is owned by $email');

  // Your data to be sent as JSON
  final Map<String, dynamic> data = {
    'id': 0,
    'storeEmail': storeEmail,
    'userEmail': userEmail,
    'menuItemId': menuItemId,
  };

  // Convert the data to JSON
  final String jsonData = jsonEncode(data);

  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    // Make a POST request to the API
    final http.Response response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://192.168.1.38:7094/api/Cart/add'
          : 'http://192.168.1.38:7094/api/Cart/add'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      log('Data sent successfully');
      return (true, response.body);
    } else {
      log('Failed to send data. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
      return (false, response.body);
    }
  } catch (e) {
    log('Error sending data: $e');
    return (false, e.toString());
  }
}
