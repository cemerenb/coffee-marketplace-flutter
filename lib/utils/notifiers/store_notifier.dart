import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../classes/stores.dart';
import '../get_user/get_user_data.dart';

class StoreNotifier extends ChangeNotifier {
  List<Store> stores = [];

  Future<void> fetchStoreUserData() async {
    final String email = await getUserData(0);
    log('Fetch all store for: $email');
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("Device is physical ${androidInfo.isPhysicalDevice.toString()}");
      final response = await http.get(Uri.parse(androidInfo.isPhysicalDevice
          ? 'http://10.0.2.2:7094/api/Store/get-all'
          : 'http://10.0.2.2:7094/api/Store/get-all'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Filter the list based on the provided email
        stores = (data as List).map((storeData) {
          return Store(
            storeEmail: storeData['storeEmail'],
            storeLogoLink: storeData['storeLogoLink'],
            storeIsOn: storeData['storeIsOn'],
            storeName: storeData['storeName'],
            storeTaxId: storeData['storeTaxId'],
            openingTime: storeData['storeOpeningTime'],
            closingTime: storeData['storeClosingTime'],
            storeCoverImageLink: storeData['storeCoverImageLink'],
            storeLatitude: storeData['latitude'],
            storeLongitude: storeData['longitude'],
          );
        }).toList();
        notifyListeners();
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
      notifyListeners();
    } finally {
      notifyListeners();
    }
  }
}
