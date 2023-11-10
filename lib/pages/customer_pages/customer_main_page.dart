import 'dart:convert';
import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

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

class _CustomerHomePageState extends State<CustomerHomePage> {
  List<Store> stores = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageSelector(currentIndex),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Padding bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 88, 88, 88).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20)),
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shadowColor: Colors.transparent),
                onPressed: () {
                  currentIndex = 1;
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.list,
                      size: 30,
                    ),
                    Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: currentIndex == 1
                              ? Colors.brown.shade600
                              : Colors.transparent),
                    )
                  ],
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shadowColor: Colors.transparent),
                onPressed: () {
                  currentIndex = 2;
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.coffee,
                      size: 30,
                    ),
                    Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: currentIndex == 2
                              ? Colors.brown.shade600
                              : Colors.transparent),
                    )
                  ],
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shadowColor: Colors.transparent),
                onPressed: () {
                  currentIndex = 3;
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.settings,
                      size: 30,
                    ),
                    Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: currentIndex == 3
                              ? Colors.brown.shade600
                              : Colors.transparent),
                    )
                  ],
                )),
          ]),
        ),
      ),
    );
  }

  Widget pageSelector(int currentIndex) {
    if (currentIndex == 1) {
      return isLoading
          ? const Center(child: CircularProgressIndicator())
          : stores.isNotEmpty
              ? StoresListView(stores: stores)
              : const Center(
                  child: Text("There are no stores"),
                );
    }
    if (currentIndex == 2) {
      return const Column();
    } else {
      return const Column();
    }
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
}

// ignore: must_be_immutable
