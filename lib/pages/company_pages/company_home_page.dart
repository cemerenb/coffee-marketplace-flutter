import 'dart:convert';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_menu_page.dart';
import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/utils/classes/menu_class.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/log_out/log_out.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CompanyHomePage extends StatefulWidget {
  CompanyHomePage({super.key, required this.currentIndex});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
  late int currentIndex;
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  List<Menu> menus = [];

  late String email;
  bool isLoading = true;
  bool isLoadingPage2 = true;

  @override
  void initState() {
    super.initState();
    log('Company Home Page');
    fetchMenuData(getUserData()).then((success) async {
      isLoadingPage2 = false;
      email = await getUserData();
    });
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
                email: email,
              ),
            );
    }
    // Handle other pages as needed.
    else {
      return Center(
        child: IconButton(
            onPressed: () {
              logOut(context);
            },
            icon: const Icon(Icons.logout)),
      );
    }
  }

  Future<void> fetchMenuData(email) async {
    log(await email);
    if (!isEmailValid(await email)) {
      log('Invalid email address');
      return;
    }

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

  bool isEmailValid(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$');
    return emailRegex.hasMatch(email);
  }
}
