import 'dart:developer';

import 'package:coffee/utils/database_operations/loyalty/create_user_loyalty.dart';
import 'package:coffee/utils/database_operations/loyalty/update_user_loyalty_points.dart';
import 'package:coffee/utils/database_operations/order/cancel_order_item.dart';
import 'package:coffee/utils/database_operations/order/update_order_status.dart';
import 'package:coffee/utils/notifiers/loyalty_program_notifier.dart';
import 'package:coffee/utils/notifiers/loyalty_user.dart';
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

bool isLoading = false;
bool isLoading2 = false;
bool isLoading3 = false;
int canceledItemCount = 0;
bool countEnabled = true;
String result = "";
int point = 0;
final TextEditingController cancelNote = TextEditingController();

class _CompanyOrderDetailsState extends State<CompanyOrderDetails> {
  @override
  void initState() {
    super.initState();
    var orderNotifier = context.read<OrderNotifier>();
    var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
    var menuNotifier = context.read<MenuNotifier>();
    var rulesNotifier = context.read<LoyaltyNotifier>();
    var userLoyaltyNotifier = context.read<LoyaltyUserNotifier>();
    orderNotifier.fetchOrderData();
    orderDetailsNotifier.fetchOrderDetailsData();
    menuNotifier.fetchMenuUserData();
    rulesNotifier.getRules();
    userLoyaltyNotifier.getPoints();

    for (var i = 0;
        i <
            orderDetailsNotifier.orderDetails
                .where((o) => o.orderId == widget.orderId)
                .length;
        i++) {
      if (orderDetailsNotifier.orderDetails
              .where((o) => o.orderId == widget.orderId)
              .toList()[i]
              .itemCanceled ==
          1) {
        canceledItemCount++;
      }
    }
  }

  @override
  void dispose() {
    canceledItemCount = 0;
    super.dispose();
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
                orderStatus(),
                orderDetails(context),
                orderNote(),
                listOrderDetails(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: bottomBar(context));
  }

  Widget orderNote() {
    var orderNotifier = context.read<OrderNotifier>();
    return orderNotifier.order
            .where((o) => o.orderId == widget.orderId)
            .first
            .orderNote
            .isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 3.0, top: 20),
                child: Text(
                  "Note",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 3,
                          color: Color.fromARGB(108, 0, 0, 0),
                          blurStyle: BlurStyle.outer,
                          spreadRadius: 0,
                          offset: Offset(1, 2))
                    ],
                    color: const Color.fromARGB(255, 249, 241, 246),
                    borderRadius: BorderRadius.circular(20)),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    orderNotifier.order
                        .where((o) => o.orderId == widget.orderId)
                        .first
                        .orderNote,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  //Bottom for change order status
  ClipRRect bottomBar(BuildContext context) {
    var orderNotifier = context.read<OrderNotifier>();
    var menuNotifier = context.read<MenuNotifier>();
    var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
    var rulesNotifier = context.read<LoyaltyNotifier>();
    var userLoyaltyNotifier = context.read<LoyaltyUserNotifier>();
    String orderStatusNote = "";
    int orderStatus = orderNotifier.order
        .where((o) => o.orderId == widget.orderId)
        .first
        .orderStatus;
    switch (orderStatus) {
      case 1:
        orderStatusNote = "Accept";
        break;
      case 2:
        orderStatusNote = "Make Ready";
        break;
      case 3:
        orderStatusNote = "Make picked up";
        break;

      default:
    }
    return orderStatus == 1 || orderStatus == 2 || orderStatus == 3
        ? ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(20)),
            child: BottomAppBar(
              color: const Color.fromARGB(255, 198, 169, 146),
              child: Row(
                mainAxisAlignment: orderStatus == 1
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  orderStatus == 1
                      ? Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width / 2.3,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 75, 75, 75),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: MaterialButton(
                              onPressed: () async {
                                isLoading2 = true;
                                setState(() {});
                                await UpdateOrderStatusApi()
                                    .updateOrderStatusStore(
                                        context, widget.orderId, 6);
                                await orderNotifier.fetchCompanyOrderData();
                                isLoading2 = false;
                                setState(() {});
                              },
                              child: isLoading2
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Center(
                                      child: Text(
                                      "Decline",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    )),
                            ),
                          ))
                      : const SizedBox(),
                  Container(
                    height: 60,
                    width: orderStatus == 1
                        ? MediaQuery.of(context).size.width / 2.3
                        : MediaQuery.of(context).size.width / 1.15,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 249, 241, 246),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: MaterialButton(
                        onPressed: () async {
                          await rulesNotifier.getRules();
                          await userLoyaltyNotifier.getPoints();
                          if (userLoyaltyNotifier.userPoints
                              .where((o) =>
                                  o.userEmail ==
                                      orderNotifier.order
                                          .where((o) =>
                                              o.orderId == widget.orderId)
                                          .first
                                          .userEmail &&
                                  o.storeEmail ==
                                      orderNotifier.order
                                          .where((o) =>
                                              o.orderId == widget.orderId)
                                          .first
                                          .storeEmail)
                              .isEmpty) {
                            if (mounted) {
                              await CreateUserLoyalty().createUserLoyalty(
                                  context,
                                  orderNotifier.order
                                      .where((o) => o.orderId == widget.orderId)
                                      .first
                                      .userEmail,
                                  orderNotifier.order
                                      .where((o) => o.orderId == widget.orderId)
                                      .first
                                      .storeEmail,
                                  0,
                                  0);
                            }
                          }
                          bool isUserPointTransfered = false;
                          // ignore: unused_local_variable
                          String response2 = "";
                          setState(() {});
                          if (orderStatus == 1 && mounted) {
                            await UpdateOrderStatusApi().updateOrderStatusStore(
                                context, widget.orderId, 2);
                            await orderNotifier.fetchCompanyOrderData();
                            setState(() {});
                          }
                          if (orderStatus == 2 && mounted) {
                            await UpdateOrderStatusApi().updateOrderStatusStore(
                                context, widget.orderId, 3);
                            await orderNotifier.fetchCompanyOrderData();
                            setState(() {});
                          }
                          if (orderStatus == 3 && mounted) {
                            await UpdateOrderStatusApi().updateOrderStatusStore(
                                context, widget.orderId, 4);
                            await orderNotifier.fetchCompanyOrderData();
                            isLoading3 = true;
                            if (mounted &&
                                rulesNotifier.rules
                                    .where((r) =>
                                        r.storeEmail ==
                                        orderNotifier.order
                                            .where((o) =>
                                                o.orderId == widget.orderId)
                                            .first
                                            .storeEmail)
                                    .isNotEmpty) {
                              Dialogs.showTransectionPopUp(context);
                            }
                            setState(() {});
                            point = userLoyaltyNotifier.userPoints
                                    .where((o) =>
                                        o.userEmail ==
                                            orderNotifier.order
                                                .where((o) =>
                                                    o.orderId == widget.orderId)
                                                .first
                                                .userEmail &&
                                        o.storeEmail ==
                                            orderNotifier.order
                                                .where((o) =>
                                                    o.orderId == widget.orderId)
                                                .first
                                                .storeEmail)
                                    .isNotEmpty
                                ? userLoyaltyNotifier.userPoints
                                    .where((o) =>
                                        o.userEmail ==
                                            orderNotifier.order
                                                .where((o) =>
                                                    o.orderId == widget.orderId)
                                                .first
                                                .userEmail &&
                                        o.storeEmail ==
                                            orderNotifier.order
                                                .where((o) =>
                                                    o.orderId == widget.orderId)
                                                .first
                                                .storeEmail)
                                    .first
                                    .totalPoint
                                : 0;
                            for (var i = 0;
                                i <
                                    orderDetailsNotifier.orderDetails
                                        .where(
                                            (o) => o.orderId == widget.orderId)
                                        .toList()
                                        .length;
                                i++) {
                              int category = menuNotifier.menu
                                  .where((m) =>
                                      m.menuItemId ==
                                      orderDetailsNotifier.orderDetails
                                          .where((o) =>
                                              o.orderId == widget.orderId)
                                          .toList()[i]
                                          .menuItemId)
                                  .first
                                  .menuItemCategory;
                              int canceled = orderDetailsNotifier.orderDetails
                                  .where((o) => o.orderId == widget.orderId)
                                  .toList()[i]
                                  .itemCanceled;
                              if (category == 1 &&
                                  canceled != 1 &&
                                  rulesNotifier.rules
                                      .where((r) =>
                                          r.storeEmail ==
                                          orderNotifier.order
                                              .where((o) =>
                                                  o.orderId == widget.orderId)
                                              .first
                                              .storeEmail)
                                      .isNotEmpty) {
                                int gain = rulesNotifier.rules
                                    .where((r) =>
                                        r.storeEmail ==
                                        orderNotifier.order
                                            .where((o) =>
                                                o.orderId == widget.orderId)
                                            .first
                                            .storeEmail)
                                    .first
                                    .category1Gain;
                                point += gain;
                              }
                              if (category == 2 &&
                                  canceled != 1 &&
                                  rulesNotifier.rules
                                      .where((r) =>
                                          r.storeEmail ==
                                          orderNotifier.order
                                              .where((o) =>
                                                  o.orderId == widget.orderId)
                                              .first
                                              .storeEmail)
                                      .isNotEmpty) {
                                int gain = rulesNotifier.rules
                                    .where((r) =>
                                        r.storeEmail ==
                                        orderNotifier.order
                                            .where((o) =>
                                                o.orderId == widget.orderId)
                                            .first
                                            .storeEmail)
                                    .first
                                    .category2Gain;
                                point += gain;
                              }
                              if (category == 3 &&
                                  canceled != 1 &&
                                  rulesNotifier.rules
                                      .where((r) =>
                                          r.storeEmail ==
                                          orderNotifier.order
                                              .where((o) =>
                                                  o.orderId == widget.orderId)
                                              .first
                                              .storeEmail)
                                      .isNotEmpty) {
                                int gain = rulesNotifier.rules
                                    .where((r) =>
                                        r.storeEmail ==
                                        orderNotifier.order
                                            .where((o) =>
                                                o.orderId == widget.orderId)
                                            .first
                                            .storeEmail)
                                    .first
                                    .category3Gain;
                                point += gain;
                              }
                              if (category == 4 &&
                                  canceled != 1 &&
                                  rulesNotifier.rules
                                      .where((r) =>
                                          r.storeEmail ==
                                          orderNotifier.order
                                              .where((o) =>
                                                  o.orderId == widget.orderId)
                                              .first
                                              .storeEmail)
                                      .isNotEmpty) {
                                int gain = rulesNotifier.rules
                                    .where((r) =>
                                        r.storeEmail ==
                                        orderNotifier.order
                                            .where((o) =>
                                                o.orderId == widget.orderId)
                                            .first
                                            .storeEmail)
                                    .first
                                    .category4Gain;
                                point += gain;
                              }
                            }
                            if (mounted &&
                                rulesNotifier.rules
                                    .where((r) =>
                                        r.storeEmail ==
                                        orderNotifier.order
                                            .where((o) =>
                                                o.orderId == widget.orderId)
                                            .first
                                            .storeEmail)
                                    .isNotEmpty) {
                              (
                                isUserPointTransfered,
                                response2
                              ) = await UpdateUserPoint().updateUserPoint(
                                  context,
                                  orderNotifier.order
                                      .where((o) => o.orderId == widget.orderId)
                                      .first
                                      .userEmail,
                                  orderNotifier.order
                                      .where((o) => o.orderId == widget.orderId)
                                      .first
                                      .storeEmail,
                                  point,
                                  userLoyaltyNotifier.userPoints
                                      .where((o) =>
                                          o.userEmail ==
                                              orderNotifier.order
                                                  .where((o) =>
                                                      o.orderId ==
                                                      widget.orderId)
                                                  .first
                                                  .userEmail &&
                                          o.storeEmail ==
                                              orderNotifier.order
                                                  .where((o) =>
                                                      o.orderId ==
                                                      widget.orderId)
                                                  .first
                                                  .storeEmail)
                                      .first
                                      .totalGained);
                            }
                            if (isUserPointTransfered &&
                                rulesNotifier.rules
                                    .where((r) =>
                                        r.storeEmail ==
                                        orderNotifier.order
                                            .where((o) =>
                                                o.orderId == widget.orderId)
                                            .first
                                            .storeEmail)
                                    .isNotEmpty) {
                              isLoading3 = false;
                              Navigator.pop(context);
                              Dialogs.showErrorDialog(context,
                                  'Transaction completed successfully');
                            }
                            if (!isUserPointTransfered &&
                                rulesNotifier.rules
                                    .where((r) =>
                                        r.storeEmail ==
                                        orderNotifier.order
                                            .where((o) =>
                                                o.orderId == widget.orderId)
                                            .first
                                            .storeEmail)
                                    .isNotEmpty) {
                              Dialogs.showErrorDialog(
                                  context, "An erro occured while transaction");
                            }

                            setState(() {});
                          }
                          setState(() {});
                        },
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Center(
                                child: Text(orderStatusNote,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300)),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const ClipRRect(
            child: SizedBox(),
          );
  }

  Column orderStatus() {
    var orderNotifier = context.read<OrderNotifier>();
    String orderStatusNote = "";
    int orderStatus = orderNotifier.order
        .where((o) => o.orderId == widget.orderId)
        .first
        .orderStatus;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 3.0, top: 20),
          child: Text(
            "Order Status",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    blurRadius: 3,
                    color: Color.fromARGB(108, 0, 0, 0),
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0,
                    offset: Offset(1, 2))
              ],
              color: const Color.fromARGB(255, 249, 241, 246),
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orderStatusNote,
                        style: const TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 198, 169, 146)),
                            onPressed: () async {
                              Dialogs().showSheet(context);
                            },
                            child: const Text(
                              "Contact Support",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 249, 241, 246)),
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
          "Order ${widget.orderId}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Column orderDetails(BuildContext context) {
    String orderStatusNote = "";

    var orderNotifier = context.read<OrderNotifier>();
    var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
    int orderStatus = orderNotifier.order
        .where((o) => o.orderId == widget.orderId)
        .first
        .orderStatus;
    var order =
        orderNotifier.order.where((o) => o.orderId == widget.orderId).first;
    canceledItemCount = 0;
    countEnabled = true;
    if (countEnabled) {
      for (var i = 0;
          i <
              orderDetailsNotifier.orderDetails
                  .where((o) => o.orderId == widget.orderId)
                  .toList()
                  .length;
          i++) {
        if (orderDetailsNotifier.orderDetails
                .where((o) => o.orderId == widget.orderId)
                .toList()[i]
                .itemCanceled ==
            1) {
          canceledItemCount += orderDetailsNotifier.orderDetails
              .where((o) => o.orderId == widget.orderId)
              .toList()[i]
              .itemCount;
        }
      }
      if (canceledItemCount ==
          orderNotifier.order
              .where((o) => o.orderId == widget.orderId)
              .first
              .itemCount) {
        UpdateOrderStatusApi()
            .updateOrderStatusStore(context, widget.orderId, 5);
      }

      countEnabled = false;
    }

    switch (orderStatus) {
      case 2:
        orderStatusNote = "item preparing";
        break;
      case 3:
        orderStatusNote = "item ready";
        break;
      case 4:
        orderStatusNote = "item picked up";
        break;

      default:
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 3.0, top: 20),
          child: Text(
            "Order Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 3,
                      color: Color.fromARGB(108, 0, 0, 0),
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0,
                      offset: Offset(1, 2))
                ],
                color: const Color.fromARGB(255, 249, 241, 246),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Order ID",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.orderId,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                      child: Divider(
                        height: 1,
                        color: Color.fromARGB(255, 229, 229, 236),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Order date",
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            Text(
                              "${order.orderCreatingTime.split("t").first.replaceAll(" ", "/")},",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              order.orderCreatingTime.split("t").last,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: orderNotifier.order
                  .where((o) => o.orderId == widget.orderId)
                  .first
                  .orderStatus !=
              1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 249, 241, 246),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 3,
                      color: Color.fromARGB(108, 0, 0, 0),
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0,
                      offset: Offset(1, 1))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          orderNotifier.order
                                      .where((o) => o.orderId == widget.orderId)
                                      .first
                                      .itemCount !=
                                  canceledItemCount
                              ? "${orderNotifier.order.where((o) => o.orderId == widget.orderId).first.itemCount - canceledItemCount} $orderStatusNote"
                              : "",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          canceledItemCount != 0 &&
                                  orderNotifier.order
                                          .where((o) =>
                                              o.orderId == widget.orderId)
                                          .first
                                          .itemCount !=
                                      canceledItemCount
                              ? ", "
                              : "",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          canceledItemCount != 0
                              ? "$canceledItemCount item canceled"
                              : "",
                          style:
                              const TextStyle(fontSize: 18, color: Colors.red),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding listOrderDetails() {
    var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
    var orderNotifier = context.read<OrderNotifier>();
    var menuNotifier = context.read<MenuNotifier>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              "Product Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 249, 241, 246),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 3,
                      color: Color.fromARGB(108, 0, 0, 0),
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0,
                      offset: Offset(1, 2))
                ]),
            child: ListView.builder(
                padding: const EdgeInsets.all(0),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          height: 1,
                          color: index == 0
                              ? Colors.transparent
                              : const Color.fromARGB(255, 229, 229, 236),
                          endIndent: 1,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
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
                                        .where(
                                            (o) => o.orderId == widget.orderId)
                                        .toList()[index]
                                        .menuItemId)
                                .first
                                .menuItemName),
                            subtitle: Text(
                                "${orderDetailsNotifier.orderDetails.where((o) => o.orderId == widget.orderId).toList()[index].itemCount} piece"),
                            trailing: orderDetailsNotifier.orderDetails
                                        .where((o) =>
                                            o.orderId == widget.orderId &&
                                            o.storeEmail == widget.email)
                                        .toList()[index]
                                        .itemCanceled !=
                                    1
                                ? Visibility(
                                    visible: orderDetailsNotifier.orderDetails
                                                .where((o) =>
                                                    o.orderId ==
                                                        widget.orderId &&
                                                    o.storeEmail ==
                                                        widget.email)
                                                .toList()[index]
                                                .itemCanceled !=
                                            1 &&
                                        orderNotifier.order
                                                .where((o) =>
                                                    o.orderId == widget.orderId)
                                                .first
                                                .orderStatus ==
                                            2,
                                    child: IconButton(
                                      style: IconButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 161, 155)),
                                      onPressed: () async {
                                        await showDataAlert(index);
                                        await orderDetailsNotifier
                                            .fetchOrderDetailsData();
                                        for (var i = 0;
                                            i <
                                                orderDetailsNotifier
                                                    .orderDetails
                                                    .where((o) =>
                                                        o.orderId ==
                                                        widget.orderId)
                                                    .length;
                                            i++) {
                                          if (orderDetailsNotifier.orderDetails
                                                  .where((o) =>
                                                      o.orderId ==
                                                      widget.orderId)
                                                  .toList()[i]
                                                  .itemCanceled ==
                                              1) {
                                            canceledItemCount++;
                                          }
                                        }
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 17,
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    height: 25,
                                    width: 60,
                                    child:
                                        const Center(child: Text("Canceled")),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<void> showDataAlert(int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
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
                                  // TODO
                                  canceledItemCount = 0;
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
