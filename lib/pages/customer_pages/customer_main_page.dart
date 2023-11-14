import 'package:coffee/pages/customer_pages/customer_list_stores.dart';

import 'package:flutter/material.dart';

import '../../utils/classes/stores.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  List<Store> stores = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
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
}

// ignore: must_be_immutable
