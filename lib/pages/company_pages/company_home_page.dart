import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_menu_page.dart';
import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/pages/company_pages/company_settings.dart';
import 'package:coffee/utils/classes/menu_class.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/classes/stores.dart';

// ignore: must_be_immutable
class CompanyHomePage extends StatefulWidget {
  CompanyHomePage({super.key, required this.currentIndex, required this.email});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
  late int currentIndex;
  late String email;
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  List<Menu> menus = [];
  List<Store> store = [];
  bool isLoading = true;
  bool isLoadingPage2 = true;

  @override
  void initState() {
    super.initState();

    log('Company Home Page');
    fetchMenuData().then((success) async {
      isLoadingPage2 = false;
    });
    fetchStoreData().then((success) async {});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageSelector(widget.currentIndex),
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
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      widget.currentIndex = 1;

                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.list,
                            size: widget.currentIndex == 1 ? 30 : 35,
                            color: widget.currentIndex == 1
                                ? Colors.brown.shade600
                                : Colors.black),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: widget.currentIndex == 1
                                  ? Colors.brown.shade600
                                  : Colors.transparent),
                        )
                      ],
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      widget.currentIndex = 2;
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.coffee,
                            size: widget.currentIndex == 2 ? 30 : 25,
                            color: widget.currentIndex == 2
                                ? Colors.brown.shade600
                                : Colors.black),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: widget.currentIndex == 2
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
                      widget.currentIndex = 3;
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.settings,
                            size: widget.currentIndex == 3 ? 30 : 25,
                            color: widget.currentIndex == 3
                                ? Colors.brown.shade600
                                : Colors.black),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: widget.currentIndex == 3
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
          : const OrdersListView();
    }
    if (currentIndex == 2) {
      return isLoadingPage2
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(0.0),
              child: MenusListView(
                menus: menus,
                email: widget.email,
              ),
            );
    }
    // Handle other pages as needed.
    else {
      return isLoadingPage2
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(0.0),
              child: StoreInfoPage(
                store: store,
                email: widget.email,
              ),
            );
    }
  }

  Future<void> fetchMenuData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.28:7094/api/Menu/get-all'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        menus = (data as List).map((menuData) {
          return Menu(
            menuItemName: menuData['menuItemName'],
            menuItemDescription: menuData['menuItemDescription'],
            menuItemImageLink: menuData['menuItemImageLink'],
            storeEmail: menuData['storeEmail'],
            menuItemIsAvaliable: menuData['menuItemIsAvaliable'],
            menuItemPrice: menuData['menuItemPrice'],
            menuItemCategory: menuData['menuItemCategory'],
          );
        }).toList();
        setState(() {});
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> fetchStoreData() async {
    final String email = await getUserData(0);
    log('Fetch Store $email');
    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.28:7094/api/Store/get-all'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        // Filter the list based on the provided email
        store = (data as List)
            .map((storeData) {
              return Store(
                storeEmail: storeData['storeEmail'],
                storeLogoLink: storeData['storeLogoLink'],
                storeName: storeData['storeName'],
                storeTaxId: storeData['storeTaxId'],
                openingTime: storeData['storeOpeningTime'],
                closingTime: storeData['storeClosingTime'],
              );
            })
            .where((store) => store.storeEmail == email)
            .toList();
        log(store.length.toString());
        setState(() {});
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  bool isEmailValid(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$');
    return emailRegex.hasMatch(email);
  }
}
