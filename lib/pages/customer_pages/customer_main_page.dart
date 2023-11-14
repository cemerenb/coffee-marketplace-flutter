import 'dart:developer';

import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:coffee/utils/log_out/log_out.dart';

import 'package:flutter/material.dart';

import '../../utils/classes/stores.dart';

// ignore: must_be_immutable
class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({
    super.key,
  });

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

List<Store> stores = [];

class _CustomerHomePageState extends State<CustomerHomePage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    log("store lenhgt:");
    log(stores.length.toString());
    if (stores.isNotEmpty) {
      isLoading = false;
    }
  }

  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                logOut(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StoresListView(stores: stores),
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
}
