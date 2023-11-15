import 'dart:convert';
import 'dart:developer';

import '../../pages/company_pages/company_settings.dart';
import '../classes/stores.dart';
import 'package:http/http.dart' as http;

import '../get_user/get_user_data.dart';

Future<void> fetchStoreData() async {
  final String email = await getUserData(0);
  log('Fetch Store $email');
  try {
    final response =
        await http.get(Uri.parse('http://192.168.0.28:7094/api/Store/get-all'));

    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      final data = json.decode(response.body);

      // Filter the list based on the provided email
      store = (data as List)
          .map((storeData) {
            return Store(
              storeEmail: storeData['storeEmail'],
              storeLogoLink: storeData['storeLogoLink'],
              storeIsOn: storeData['storeIsOn'],
              storeName: storeData['storeName'],
              storeTaxId: storeData['storeTaxId'],
              openingTime: storeData['storeOpeningTime'],
              closingTime: storeData['storeClosingTime'],
              storeCoverImageLink: storeData['storeCoverImageLink'],
            );
          })
          .where((store) => store.storeEmail == email)
          .toList();
      log(store.length.toString());
    } else {
      log('Error: ${response.statusCode}');
    }
  } catch (e) {
    log('Error: $e');
  }
}
