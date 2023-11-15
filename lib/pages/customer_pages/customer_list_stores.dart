import 'dart:developer';

import 'package:coffee/pages/customer_pages/customer_store_details.dart';
import 'package:coffee/utils/database_operations/get_menu_user.dart';
import 'package:coffee/utils/database_operations/get_store_data_user.dart';
import 'package:coffee/utils/log_out/log_out.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../utils/classes/menu_class.dart';
import '../../utils/classes/stores.dart';

// ignore: must_be_immutable
class StoresListView extends StatefulWidget {
  const StoresListView({
    super.key,
    required this.stores,
  });

  final List<Store> stores;

  @override
  State<StoresListView> createState() => _StoresListViewState();
}

List<Menu> menu = [];
bool isSearchBarOn = false;
final TextEditingController search = TextEditingController();

class _StoresListViewState extends State<StoresListView> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              logOut(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: 50,
                child: Center(
                  child: TextField(
                    controller: search,
                    onTap: () {
                      isSearchBarOn = true;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        labelText: 'Search store',
                        suffixIcon: isSearchBarOn
                            ? IconButton(
                                onPressed: () {
                                  search.clear();
                                  isSearchBarOn = false;
                                },
                                icon: const Icon(Icons.cancel))
                            : IconButton(
                                onPressed: () {
                                  isSearchBarOn = true;
                                },
                                icon: const Icon(Icons.search)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  if (stores[index].storeLogoLink.isNotEmpty &&
                          stores[index]
                              .storeName
                              .toLowerCase()
                              .contains(search.text.toLowerCase()) ||
                      search.text == "") {
                    count++;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Card(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                log(index.toString());
                                await fetchStoreUserData();
                                await fetchMenuUserData();
                                if (context.mounted) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StoreDetails(index: index),
                                      ));
                                }
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  child: Image.network(
                                    stores[index].storeCoverImageLink,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () async {
                                log(index.toString());
                                await fetchStoreUserData();
                                await fetchMenuUserData();

                                if (context.mounted) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StoreDetails(index: index),
                                      ));
                                }
                              },
                              leading: SizedBox(
                                height: 80,
                                width: 80,
                                child: Image.network(
                                  stores[index].storeLogoLink,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              title: Text(stores[index].storeName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${stores[index].openingTime.replaceAll(" ", "")} - ${stores[index].closingTime.replaceAll(" ", "")}'),
                                  const Row(
                                    children: [
                                      Text('-'),
                                      Icon(
                                        Icons.star,
                                        color:
                                            Color.fromARGB(255, 216, 196, 19),
                                        size: 20,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (count == 0) {
                    count++;
                    return const Center(
                      child: Text("There is not any stores"),
                    );
                  }
                  // Replace the following line with a default widget, for example:
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
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
                  fetchStoreUserData();
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.home, size: 30, color: Colors.brown.shade600),
                    Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.brown.shade600),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shadowColor: Colors.transparent),
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.coffee, size: 25, color: Colors.black),
                    Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shadowColor: Colors.transparent),
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.settings, size: 25, color: Colors.black),
                    Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
