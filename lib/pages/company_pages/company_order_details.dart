import 'dart:developer';

import 'package:coffee/utils/database_operations/order/cancel_order_item.dart';
import 'package:coffee/utils/notifiers/order_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notifiers/menu_notifier.dart';
import '../../utils/notifiers/order_details_notifier.dart';
import '../../widgets/dialogs.dart';

class CompanyOrderDetails extends StatefulWidget {
  const CompanyOrderDetails(
      {super.key,
      required this.email,
      required this.orderId,
      required this.userName});

  @override
  State<CompanyOrderDetails> createState() => _CompanyOrderDetailsState();
  final String email;
  final String orderId;
  final String userName;
}

final TextEditingController cancelNote = TextEditingController();

class _CompanyOrderDetailsState extends State<CompanyOrderDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              appBar(context),
              const SizedBox(
                height: 10,
              ),
              orderDetails(context),
              listOrderDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Row appBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        Text(
          "Orded ${widget.orderId}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Container orderDetails(BuildContext context) {
    var orderNotifier = context.read<OrderNotifier>();
    orderNotifier.fetchOrderData();
    var order =
        orderNotifier.order.where((o) => o.orderId == widget.orderId).first;
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(order.orderCreatingTime.split("t").first),
                  Text(order.orderCreatingTime.split("t").last),
                  Row(
                    children: [
                      Text(
                        "${order.itemCount} piece",
                        style: const TextStyle(fontSize: 25),
                      ),
                      Text(
                        " ${order.orderTotalPrice}₺",
                        style: const TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding listOrderDetails() {
    var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
    var menuNotifier = context.read<MenuNotifier>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orderDetailsNotifier.orderDetails
                      .where((o) =>
                          o.orderId == widget.orderId &&
                          o.storeEmail == widget.email)
                      .length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ListTile(
                          leading: SizedBox(
                            height: 60,
                            width: 60,
                            child: Image.network(
                              menuNotifier.menu
                                  .where((m) =>
                                      m.menuItemId ==
                                      orderDetailsNotifier.orderDetails
                                          .where((o) =>
                                              o.orderId == widget.orderId)
                                          .toList()[index]
                                          .menuItemId)
                                  .first
                                  .menuItemImageLink,
                              fit: BoxFit.contain,
                            ),
                          ),
                          title: Text(menuNotifier.menu
                              .where((m) =>
                                  m.menuItemId ==
                                  orderDetailsNotifier.orderDetails
                                      .where((o) => o.orderId == widget.orderId)
                                      .toList()[index]
                                      .menuItemId)
                              .first
                              .menuItemName),
                          subtitle: Text(
                              "${orderDetailsNotifier.orderDetails.where((o) => o.orderId == widget.orderId).toList()[index].itemCount} piece"),
                          trailing: Visibility(
                            visible: orderDetailsNotifier.orderDetails
                                    .where((o) =>
                                        o.orderId == widget.orderId &&
                                        o.storeEmail == widget.email)
                                    .toList()[index]
                                    .itemCanceled !=
                                1,
                            child: Positioned(
                              top: 0,
                              right: 0,
                              child: SizedBox(
                                height: 35,
                                width: 35,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 161, 155)),
                                  onPressed: () async {
                                    await showDataAlert(index);
                                    await orderDetailsNotifier
                                        .fetchOrderDetailsData();
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: orderDetailsNotifier.orderDetails
                                  .where((o) =>
                                      o.orderId == widget.orderId &&
                                      o.storeEmail == widget.email)
                                  .toList()[index]
                                  .itemCanceled ==
                              1,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 10,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(136, 77, 77, 77),
                            ),
                            height: 78,
                            child: const Center(
                              child: Text(
                                'Canceled',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  Future<void> showDataAlert(int index) async {
    var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Cancel Item",
                  style: TextStyle(fontSize: 24.0),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      cancelNote.clear();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              height: 400,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text(
                      'Reason for product cancellation',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 200,
                      textInputAction: TextInputAction.done,
                      controller: cancelNote,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black))),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                log(orderDetailsNotifier.orderDetails
                                    .where((o) => o.orderId == widget.orderId)
                                    .first
                                    .storeEmail
                                    .toString());
                                log(orderDetailsNotifier.orderDetails
                                    .where((o) => o.orderId == widget.orderId)
                                    .first
                                    .menuItemId
                                    .toString());
                                log(orderDetailsNotifier.orderDetails
                                    .where((o) => o.orderId == widget.orderId)
                                    .first
                                    .orderId
                                    .toString());
                                bool isCompleted = false;
                                // ignore: unused_local_variable
                                String response = "";
                                if (cancelNote.text.length < 15) {
                                  Dialogs.showErrorDialog(context,
                                      "Cancellation note must be at least 15 characters");
                                } else {
                                  (isCompleted, response) =
                                      await CancelOrderItem().cancelOrderItem(
                                          context,
                                          orderDetailsNotifier.orderDetails
                                              .where((o) =>
                                                  o.orderId == widget.orderId)
                                              .toList()[index]
                                              .storeEmail,
                                          orderDetailsNotifier.orderDetails
                                              .where((o) =>
                                                  o.orderId == widget.orderId)
                                              .toList()[index]
                                              .menuItemId,
                                          orderDetailsNotifier.orderDetails
                                              .where((o) =>
                                                  o.orderId == widget.orderId)
                                              .toList()[index]
                                              .orderId,
                                          1,
                                          cancelNote.text);
                                }
                                if (isCompleted) {
                                  await OrderDetailsNotifier()
                                      .fetchOrderDetailsData();
                                  cancelNote.clear();
                                  setState(() {});
                                  if (mounted) {
                                    setState(() {});
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: const Text('Cancel Order'))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
