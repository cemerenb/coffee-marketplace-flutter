// store_info_page.dart

import 'dart:developer';

import 'package:coffee/main.dart';
import 'package:coffee/pages/company_pages/company_menu_page.dart';
import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/pages/company_pages/widgets/complete_store_account.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/log_out/log_out.dart';
import 'package:flutter/material.dart';
import '../../utils/classes/stores.dart';
import '../../utils/database_operations/store/get_store_data.dart';
import '../../utils/database_operations/store/toggle_store.dart';

class StoreInfoPage extends StatefulWidget {
  final String email;

  const StoreInfoPage({Key? key, required this.email}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StoreInfoPageState createState() => _StoreInfoPageState();
}

int currentIndex = 3;
List<Store> store = [];

class _StoreInfoPageState extends State<StoreInfoPage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = false;
    String responseMessage = "";
    return Scaffold(
      body: store[0].storeLogoLink.isEmpty
          ? AccountNotCompleted(
              widget: widget,
              email: email,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  LogoArea(
                    widget: widget,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        toggleStoreIsOnArea(
                            context, isCompleted, responseMessage),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.3,
                          height: 170,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15)),
                          child: IconButton(
                              onPressed: () {
                                logOut(context);
                                setState(() {});
                              },
                              icon: const Icon(Icons.logout_outlined)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Container toggleStoreIsOnArea(
      BuildContext context, bool isCompleted, String responseMessage) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      height: 170,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Store',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      store[0].storeIsOn == 1 ? 'On' : 'Off',
                      style: TextStyle(
                          color: store[0].storeIsOn == 1
                              ? Colors.green
                              : Colors.red,
                          fontSize: 50),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Switch(
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                  activeColor: const Color.fromARGB(255, 13, 104, 16),
                  value: store[0].storeIsOn == 1,
                  onChanged: (value) async {
                    if (store[0].storeIsOn == 1) {
                      (isCompleted, responseMessage) = await ToggleStoreStatus()
                          .toggleStoreStatus(context, store[0].storeEmail, 0);
                      log(isCompleted.toString());
                      log(responseMessage);
                      await fetchStoreData();
                      setState(() {});
                    } else {
                      (isCompleted, responseMessage) = await ToggleStoreStatus()
                          .toggleStoreStatus(context, store[0].storeEmail, 1);
                      await fetchStoreData();
                      log(isCompleted.toString());
                      log(responseMessage);
                      setState(() {});
                    }
                  },
                ),
              ],
            )
          ],
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrdersListView(),
                          ));
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.list, size: 25, color: Colors.black),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent),
                        )
                      ],
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      final String email = await getUserData(0);
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenusListView(email: email),
                            ));
                      }

                      setState(() {});
                    },
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
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      await fetchStoreData();
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.settings,
                            size: 30, color: Colors.brown.shade600),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.brown.shade600),
                        )
                      ],
                    )),
              ]),
        ),
      ),
    );
  }
}

class LogoArea extends StatelessWidget {
  const LogoArea({
    super.key,
    required this.widget,
  });

  final StoreInfoPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.network(
              store[0].storeLogoLink,
              height: 130,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome back!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300)),
                    Text(
                      store[0].storeName,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_right_alt,
                          size: 35,
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AccountNotCompleted extends StatelessWidget {
  const AccountNotCompleted(
      {super.key, required this.widget, required this.email});

  final StoreInfoPage widget;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    top: 15,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome ",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          store[0].storeName,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 25),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Your account not completed yet"),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompleteAccount(
                                      store: store, email: email),
                                ));
                          },
                          icon: const Icon(
                            Icons.arrow_right_alt,
                            size: 35,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
