import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

Future<String> getUser(String email) async {
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
    final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
        ? 'http://10.0.2.2:7094/api/User/get-users-name?email=$email'
        : 'http://10.0.2.2:7094/api/User/get-users-name?email=$email'));

    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      return response.body;
    } else {
      log('Error: ${response.statusCode}');
      return response.statusCode.toString();
    }
  } catch (e) {
    log('Error: $e');
    return e.toString();
  }
}
