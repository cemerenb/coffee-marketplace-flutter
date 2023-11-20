import 'dart:async';
import 'dart:developer';

import 'package:coffee/pages/customer_pages/customer_cart.dart';
import 'package:coffee/pages/customer_pages/customer_store_details.dart';
import 'package:coffee/pages/customer_pages/settings_page.dart';
import 'package:coffee/utils/classes/order_class.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/notifiers/order_notifier.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notifiers/cart_notifier.dart';
import '../../utils/notifiers/menu_notifier.dart';
import '../../utils/notifiers/store_notifier.dart';

class StoresListView extends StatefulWidget {
  const StoresListView({
    super.key,
  });

  @override
  State<StoresListView> createState() => _StoresListViewState();
}

bool isSearchBarOn = false;
bool isLoading = true;
bool activeOrderFound = false;
int index = 0;
bool c1 = false;
bool c2 = false;
bool c3 = false;
bool c4 = false;
bool check = true;
late Timer timer;
final TextEditingController search = TextEditingController();

class _StoresListViewState extends State<StoresListView> {
  @override
  void initState() {
    var orderNotifier = context.read<OrderNotifier>();
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => checkOrder(),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    check = false;
    super.dispose();
  }

  int count = 0;
  int orderStatus = 1;
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: IconButton(
              onPressed: () async {
                if (context.mounted) {
                  await context.read<StoreNotifier>().fetchStoreUserData();
                }
                if (context.mounted) {
                  await context.read<MenuNotifier>().fetchMenuUserData();
                }
                if (context.mounted) {
                  await context.read<CartNotifier>().getCart();
                }
                if (context.mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ));
                }
              },
              icon: const Icon(Icons.shopping_cart_outlined,
                  size: 25, color: Colors.black),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            searchField(),
            orderInfoArea(context),
            listStores(),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Container orderInfoArea(BuildContext context) {
    var orderNotifier = context.watch<OrderNotifier>();

    return Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
        ),
        child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20)),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : orderNotifier.order.isEmpty
                    ? const Text("No order to shown")
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)),
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(orderNotifier.order[index].orderId),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 7,
                                    height: 5,
                                    color: orderStatus > 0
                                        ? Colors.brown.shade400
                                        : Colors.black.withOpacity(0.3),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 7,
                                    height: 5,
                                    color: orderStatus > 1
                                        ? Colors.brown.shade400
                                        : Colors.black.withOpacity(0.3),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 7,
                                    height: 5,
                                    color: orderStatus > 2
                                        ? Colors.brown.shade400
                                        : Colors.black.withOpacity(0.3),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 7,
                                    height: 5,
                                    color: orderStatus > 3
                                        ? Colors.brown.shade400
                                        : Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )));
  }

  Future<bool> checkOrder() async {
    if (!context.mounted) return false;

    var orderNotifier = context.read<OrderNotifier>();
    await context.read<OrderNotifier>().fetchOrderData();
    if (orderNotifier.order.isNotEmpty) {
      for (var i = 0; i < orderNotifier.order.length; i++) {
        if (orderNotifier.order[i].orderStatus < 5) {
          index = i;
          isLoading = false;
          setState(() {});
        }
      }
      if (orderNotifier.order.isNotEmpty) {
        orderStatus = orderNotifier.order[index].orderStatus;

        setState(() {});
        log("c1: $c1, c2: $c2, c3: $c3, c4: $c4");
      }
      setState(() {});
      return true;
    } else {
      isLoading = false;
      setState(() {});
      log("No order found");
      return false;
    }
  }

  Expanded listStores() {
    var storeNotifier = context.watch<StoreNotifier>();
    return Expanded(
      child: ListView.builder(
        itemCount: storeNotifier.stores.length,
        itemBuilder: (context, index) {
          if (storeNotifier.stores[index].storeLogoLink.isNotEmpty &&
              storeNotifier.stores[index].storeName
                  .toLowerCase()
                  .contains(search.text.toLowerCase())) {
            count++;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Card(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (storeNotifier.stores[index].storeIsOn == 1) {
                          log(index.toString());
                          if (context.mounted) {
                            await context
                                .read<StoreNotifier>()
                                .fetchStoreUserData();
                          }
                          if (context.mounted) {
                            await context
                                .read<MenuNotifier>()
                                .fetchMenuUserData();
                          }
                          email = await getUserData(0);
                          if (context.mounted) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoreDetails(
                                    index: index,
                                    email: email,
                                  ),
                                ));
                          }
                        }
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              child: Image.network(
                                storeNotifier.stores[index].storeCoverImageLink,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Visibility(
                              visible:
                                  storeNotifier.stores[index].storeIsOn == 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        width: 60,
                                        height: 22,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 240, 88, 77),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Center(
                                            child: Text('Closed'))),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      enabled: storeNotifier.stores[index].storeIsOn == 1,
                      onTap: () async {
                        log(index.toString());
                        if (context.mounted) {
                          await context
                              .read<StoreNotifier>()
                              .fetchStoreUserData();
                        }
                        if (context.mounted) {
                          await context
                              .read<MenuNotifier>()
                              .fetchMenuUserData();
                        }
                        if (context.mounted) {
                          await context.read<CartNotifier>().getCart();
                        }
                        email = await getUserData(0);
                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoreDetails(
                                  index: index,
                                  email: email,
                                ),
                              ));
                        }
                      },
                      leading: SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.network(
                          storeNotifier.stores[index].storeLogoLink,
                          fit: BoxFit.contain,
                        ),
                      ),
                      title: Text(storeNotifier.stores[index].storeName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${storeNotifier.stores[index].openingTime.replaceAll(" ", "")} - ${storeNotifier.stores[index].closingTime.replaceAll(" ", "")}'),
                          const Row(
                            children: [
                              Text('-'),
                              Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 216, 196, 19),
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
    );
  }

  Padding searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 50,
        child: Center(
          child: TextField(
            controller: search,
            onTap: () {
              isSearchBarOn = true;
              setState(() {});
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
                          setState(() {});
                        },
                        icon: const Icon(Icons.cancel))
                    : IconButton(
                        onPressed: () {
                          isSearchBarOn = true;
                          setState(() {});
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
                  if (context.mounted) {
                    await context.read<StoreNotifier>().fetchStoreUserData();
                  }
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.home_outlined,
                        size: 30, color: Colors.brown.shade600),
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
                    const Icon(Icons.shopping_bag_outlined,
                        size: 25, color: Colors.black),
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.settings_outlined,
                        size: 25, color: Colors.black),
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
