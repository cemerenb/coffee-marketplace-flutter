// api_service.dart

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../classes/stores.dart';

class ApiService {
  static Future<Store?> getStoreInfo(String email) async {
    const apiUrl = 'http://192.168.0.28:7094/api/Store/get-all';
    log(email);
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          // If the data is a map, proceed as before
          if (data['storeEmail'] == email) {
            return Store(
              storeEmail: data['storeEmail'],
              storeName: data['storeName'],
              storeTaxId: data['storeTaxId'],
              storeLogoLink: data['storeLogoLink'],
              storeIsOn: data['storeIsOn'],
              openingTime: data['openingTime'],
              closingTime: data['closingTime'],
            );
          } else {
            return null;
          }
        } else if (data is List<dynamic>) {
          // If the data is a list, assume the first element contains the store information
          if (data.isNotEmpty) {
            final storeData = data[0];
            return Store(
              storeEmail: storeData['storeEmail'],
              storeName: storeData['storeName'],
              storeTaxId: storeData['storeTaxId'],
              storeLogoLink: storeData['storeLogoLink'],
              storeIsOn: storeData['storeIsOn'],
              openingTime: storeData['openingTime'],
              closingTime: storeData['closingTime'],
            );
          } else {
            return null;
          }
        } else {
          // Unexpected data type
          throw Exception('Unexpected data type in API response');
        }
      } else {
        throw Exception('Failed to load store information');
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }
}
