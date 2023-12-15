import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class CheckUserToken {
  CheckUserToken();

  Future<(bool success, String message)> checkToken(
    String email,
    String token,
  ) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");

      final response = await http.post(
        Uri.parse(androidInfo.isPhysicalDevice
            ? 'http://10.0.2.2:7094/api/User/check-reset-token'
            : 'http://10.0.2.2:7094/api/User/check-reset-token'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            <String, String>{'email': email, 'passwordResetToken': token}),
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