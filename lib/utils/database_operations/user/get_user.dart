import 'dart:developer';
import 'package:http/http.dart' as http;

Future<String> getUser(String email) async {
  try {
    final response = await http.get(Uri.parse(
        'http://192.168.0.28:7094/api/User/get-users-name?email=$email'));

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
