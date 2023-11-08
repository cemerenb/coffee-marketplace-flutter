import 'package:coffee/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Store {
  final String storeName;
  final String storeLogoLink;
  final String openingTime;
  final String closingTime;

  Store({
    required this.storeName,
    required this.storeLogoLink,
    required this.openingTime,
    required this.closingTime,
  });
}

class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CompanyHomePageState createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  List<Store> stores = [];
  bool isLoading = true; // Added loading indicator state

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://192.168.0.28:7094/api/Store/get-all'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        stores = (data as List)
            .map((storeData) {
              if (storeData['storeOpeningTime'] != null) {
                return Store(
                  storeName: storeData['storeName'],
                  storeLogoLink: storeData['storeLogoLink'],
                  openingTime: storeData['storeOpeningTime'],
                  closingTime: storeData['storeClosingTime'],
                );
              }
              return null; // Skip this store
            })
            .where((store) => store != null)
            .map((store) => store!)
            .toList();
        isLoading = false; // Data is loaded, set loading to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : stores.isNotEmpty
              ? StoresListView(stores: stores)
              : const Center(
                  child: Text("There are no stores"),
                ),
    );
  }
}

class StoresListView extends StatelessWidget {
  StoresListView({
    super.key,
    required this.stores,
  });

  final List<Store> stores;

  @override
  Widget build(BuildContext context) {
    final filteredStores =
        stores.where((store) => store.storeLogoLink.isNotEmpty).toList();

    if (filteredStores.isEmpty) {
      return Center(
        child: Text("There is not any stores"),
      );
    } else {
      return ListView.builder(
          itemCount: filteredStores.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Image.network(stores[index].storeLogoLink),
                title: Text(stores[index].storeName),
                subtitle: Text(
                    'Open: ${stores[index].openingTime} - Close: ${stores[index].closingTime}'),
              ),
            );
          });
    }
  }
}
