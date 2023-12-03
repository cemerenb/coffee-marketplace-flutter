import 'dart:async';

import 'package:coffee/utils/notifiers/order_details_notifier.dart';
import 'package:coffee/utils/notifiers/order_notifier.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerOrdersPage extends StatefulWidget {
  const CustomerOrdersPage({super.key, required this.email});

  @override
  State<CustomerOrdersPage> createState() => _CustomerOrdersPageState();
  final String email;
}

late Timer timer;

class _CustomerOrdersPageState extends State<CustomerOrdersPage> {
  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => checkOrder(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Orders"),
      ),
      body: listOrders(),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Padding listOrders() {
    var orderNotifier = context.watch<OrderNotifier>();
    var storeNotifier = context.watch<StoreNotifier>();
    var orderDetailsNotifier = context.watch<OrderDetailsNotifier>();
    var order = orderNotifier.order.where((o) => o.userEmail == widget.email);
    String orderStatusNote = "";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: order.length,
              itemBuilder: (context, index) {
                int orderStatus = order.toList()[index].orderStatus;
                switch (orderStatus) {
                  case 1:
                    orderStatusNote = "Pending accept";
                    break;
                  case 2:
                    orderStatusNote = "Preparing order";
                    break;
                  case 3:
                    orderStatusNote = "Order ready";
                    break;
                  case 4:
                    orderStatusNote = "Order completed";
                    break;
                  case 5:
                    orderStatusNote = "Order canceled";
                    break;
                  case 6:
                    orderStatusNote = "Order declined";
                    break;
                  default:
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      storeNotifier.stores
                                          .where((s) =>
                                              s.storeEmail ==
                                              order.toList()[index].storeEmail)
                                          .first
                                          .storeName,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(order.toList()[index].orderId),
                                    Text(order
                                        .toList()[index]
                                        .orderCreatingTime
                                        .replaceAll("t", " ")),
                                    Text(
                                        "Total: ${orderNotifier.order[index].orderTotalPrice} ₺"),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Details")),
                                  ],
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  orderStatus == 5 || orderStatus == 6
                                      ? Icons.close
                                      : orderStatus == 4
                                          ? Icons.done
                                          : Icons.timer_outlined,
                                  color: orderStatus == 5 || orderStatus == 6
                                      ? const Color.fromARGB(255, 223, 96, 87)
                                      : orderStatus == 4
                                          ? Colors.green
                                          : Colors.brown.shade400,
                                  size: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(orderStatusNote),
                                ),
                                Text(
                                  orderDetailsNotifier.orderDetails
                                      .where((od) =>
                                          od.orderId ==
                                          orderNotifier.order
                                              .toList()[index]
                                              .orderId)
                                      .map((od) => od.itemCount.toString())
                                      .join(
                                          ', '), // Concatenate item counts with a separator
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<bool> checkOrder() async {
    if (mounted) {
      var orderNotifier = context.read<OrderNotifier>();
      await orderNotifier.fetchOrderData();
      if (mounted) {
        await context.read<OrderNotifier>().fetchOrderData();
      }
    }
    return false;
  }
}
