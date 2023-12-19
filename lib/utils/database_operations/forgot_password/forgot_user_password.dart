import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class ForgotUserPassword {
  ForgotUserPassword();

  static const baseUrl = 'http://10.0.2.2:7094/api/User/';

  Future<(bool success, String message)> forgotUserPassword(
    String email,
  ) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final response = await http.post(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/User/forgot-password?email=$email'
          : 'http://10.0.2.2:7094/api/User/forgot-password?email=$email'));

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
