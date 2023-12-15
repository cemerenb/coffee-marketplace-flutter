import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class ForgotStorePassword {
  ForgotStorePassword();

  Future<(bool success, String message)> forgotStorePassword(
    String email,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://192.168.1.38:7094/api/Store/forgot-password'
          : 'http://192.168.1.38:7094/api/Store/forgot-password'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
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
  }
}
