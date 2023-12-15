import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class ForgotUserPassword {
  ForgotUserPassword();

  static const baseUrl = 'http://192.168.1.38:7094/api/User/';

  Future<(bool success, String message)> forgotUserPassword(
    String email,
  ) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");

      final url = Uri.parse('${baseUrl}forgot-password');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log('Mail sent successfully');
        return (true, response.body);
      } else {
        log('Error');
        log(response.body);
        return (false, response.body);
      }
    } catch (e) {
      log('Exception: $e');
      return (false, 'An error occurred: $e');
    }
  }
}
