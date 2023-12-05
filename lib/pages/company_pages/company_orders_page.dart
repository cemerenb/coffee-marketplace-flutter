import 'dart:async';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_menu_page.dart';
import 'package:coffee/pages/company_pages/company_order_details.dart';
import 'package:coffee/pages/company_pages/company_scan_qr_code.dart';
import 'package:coffee/pages/company_pages/company_settings.dart';
import 'package:coffee/utils/database_operations/user/get_user.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/notifiers/menu_notifier.dart';
import 'package:coffee/utils/notifiers/order_details_notifier.dart';
import 'package:coffee/utils/notifiers/order_notifier.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/database_operations/store/get_menu.dart';

class OrdersListView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const OrdersListView({super.key, required this.email});
  final String email;
  @override
  State<OrdersListView> createState() => _OrdersListViewState();
}

bool isLoading = true;
bool activeOrderFound = false;
int index = 0;
bool c1 = false;
bool c2 = false;
bool c3 = false;
bool c4 = false;
bool check = true;
bool isNameLoading = true;

String? _user;
late Timer timer;

class _OrdersListViewState extends State<OrdersListView> {
  @override
  void initState() {
    checkOrder();
    super.initState();
    context.read<OrderDetailsNotifier>().fetchOrderDetailsData();
    context.read<MenuNotifier>().fetchMenuUserData();
    log("init");
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer t) => checkOrder(),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    check = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompanyScanQrCode(),
                  ));
            },
            icon: const Icon(Icons.qr_code_outlined)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list))
        ],
      ),
      body: listCompanyOrders(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Padding listCompanyOrders() {
    var orderNotifier = context.read<OrderNotifier>();
    var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
    var menuNotifier = context.read<MenuNotifier>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: orderNotifier.order
                    .where((order) => order.storeEmail == widget.email)
                    .length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () async {
                        final userName =
                            await getUser(orderNotifier.order[index].userEmail);
                        if (mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompanyOrderDetails(
                                  email: widget.email,
                                  orderId: orderNotifier.order[index].orderId,
                                  userName: userName,
                                ),
                              ));
                        }
                      },
                      leading: SizedBox(
                        width: 70,
                        height: 70,
                        child: Stack(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 219, 214, 214),
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.network(
                                  menuNotifier.menu
                                      .where((m) =>
                                          m.menuItemId ==
                                          orderDetailsNotifier.orderDetails
                                              .where((o) =>
                                                  o.orderId ==
                                                  orderNotifier
                                                      .order[index].orderId)
                                              .first
                                              .menuItemId)
                                      .first
                                      .menuItemImageLink,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: orderNotifier.order[index].itemCount > 1,
                              child: Positioned(
                                  right: 0,
                                  child: Container(
                                    height: 23,
                                    width: 23,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color.fromARGB(255, 198, 169, 146)),
                                    child: Center(
                                      child: Text(
                                          "+${orderNotifier.order[index].itemCount - 1}"),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      title: FutureBuilder<String>(
                        future: getUser(orderNotifier.order[index].userEmail),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              isNameLoading == true) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            isNameLoading = false;
                            _user = snapshot.data;
                            return Text(_user ?? '');
                          }
                        },
                      ),
                      subtitle: Text(orderNotifier.order[index].orderId),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Future<bool> checkOrder() async {
    if (mounted) {
      var orderNotifier = context.read<OrderNotifier>();
      await context.read<OrderDetailsNotifier>().fetchOrderDetailsData();
      if (mounted) {
        await context.read<MenuNotifier>().fetchMenuUserData();
      }
      if (mounted) {
        await context.read<OrderNotifier>().fetchCompanyOrderData();
      }

      if (orderNotifier.order.isNotEmpty) {
        isLoading = false;

        if (orderNotifier.order.isNotEmpty) {
          if (mounted) {
            context.read<OrderNotifier>().fetchCompanyOrderData();
          }
          if (mounted) {
            setState(() {});
          }

          log("order data fetched");
        }
        if (mounted) {
          setState(() {});
        }

        return true;
      } else {
        isLoading = false;
        if (mounted) {
          setState(() {});
        }

        log("No order found");
        return false;
      }
    }
    return false;
  }

  Padding bottomNavigationBar() {
    var orderNotifier = context.watch<OrderNotifier>();
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
                      log(widget.email);
                      log(orderNotifier.order
                          .where((order) => order.storeEmail == widget.email)
                          .toString());
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.list,
                            size: 30,
                            color: Color.fromARGB(255, 198, 169, 146)),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 198, 169, 146)),
                        )
                      ],
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      final String email = await getUserData(0);
                      await fetchMenuData();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenusListView(email: email),
                            ),
                            (route) => false);
                        setState(() {});
                      }
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
                      var storeNotifier = context.read<StoreNotifier>();
                      await storeNotifier.fetchStoreUserData();
                      final String email = await getUserData(0);
                      await StoreNotifier().fetchStoreUserData();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreInfoPage(email: email),
                            ),
                            (route) => false);
                        setState(() {});
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.settings,
                            size: 25, color: Colors.black),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent),
                        )
                      ],
                    )),
              ]),
        ),
      ),
    );
  }
}
