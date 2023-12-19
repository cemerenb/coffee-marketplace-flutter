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

class RatingCreationApi {
  RatingCreationApi();

  Future<bool> createRating(BuildContext context, String storeEmail,
      String orderId, int ratingPoint, String comment) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final prefs = await SharedPreferences.getInstance();

    final String token = await getToken();

    final response = await http.post(
      Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Rating/add-rating'
          : 'http://10.0.2.2:7094/api/Rating/add-rating'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        'ratingId': "",
        'storeEmail': storeEmail,
        'accessToken': token,
        'orderId': orderId,
        'ratingPoint': ratingPoint,
        'comment': comment,
        'ratingDate':
            "${DateTime.now().day < 10 ? "0${DateTime.now().day}" : "${DateTime.now().day}"} ${DateTime.now().month < 10 ? "0${DateTime.now().month}" : "${DateTime.now().month}"} ${DateTime.now().year}t${(DateTime.now().hour + 3) % 24 < 9 ? "0${(DateTime.now().hour + 3) % 24}" : "${(DateTime.now().hour + 3) % 24}"}:${DateTime.now().minute < 9 ? "0${DateTime.now().minute}" : "${DateTime.now().minute}"}",
      }),
    );

    if (response.statusCode == 200) {
      log('Rating successfully created');
      if (context.mounted) {
        await Dialogs.showErrorDialog(context, response.body);
      }
      return true;
    }

    if (response.statusCode == 210 && context.mounted) {
      await Dialogs.showErrorDialog(
          context, "Session has expired please log in again");
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('accessToken');
      await prefs.remove('accountType');
      await prefs.remove('refreshToken');
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(isSwitched: false),
            ),
            (route) => false);
      }
      return false;
    }

    if (response.statusCode == 211 && context.mounted) {
      bool isCompleted = false;
      String token = "";
      (isCompleted, token) =
          await UpdateRefreshToken().updateRefreshToken(context);
      if (isCompleted) {
        await prefs.remove("accessToken");
        await prefs.setString("accessToken", token);
      }
      if (context.mounted) {
        RatingCreationApi()
            .createRating(context, storeEmail, orderId, ratingPoint, comment);
      }
      return false;
    } else {
      if (context.mounted) {
        await Dialogs.showErrorDialog(context, response.body);
      }
      log('Error');
      log(response.body);
      return false;
    }
  }
}
