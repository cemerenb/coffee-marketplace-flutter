import 'dart:convert';
import 'dart:developer';

import 'package:coffee/utils/classes/rating_class.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RatingNotifier extends ChangeNotifier {
  List<Rating> ratings = [];

  Future<void> fetchRatingsData() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
      final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Rating/get-all'
          : 'http://10.0.2.2:7094/api/Rating/get-all'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        ratings = (data as List).map((ratingData) {
          return Rating(
              ratingId: ratingData['ratingId'],
              storeEmail: ratingData['storeEmail'],
              orderId: ratingData['orderId'],
              userEmail: ratingData['userEmail'],
              ratingPoint: ratingData['ratingPoint'],
              comment: ratingData['comment'],
              isRatingDisplayed: ratingData['isRatingDisplayed'],
              ratingDisabledComment: ratingData['ratingDisabledComment'],
              ratingDate: ratingData['ratingDate']);
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
