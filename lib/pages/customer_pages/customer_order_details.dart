import 'package:coffee/utils/database_operations/rating/add_rating.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/notifiers/order_notifier.dart';
import 'package:coffee/utils/notifiers/rating_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notifiers/menu_notifier.dart';
import '../../utils/notifiers/order_details_notifier.dart';
import '../../widgets/dialogs.dart';

class CustomerOrderDetails extends StatefulWidget {
  const CustomerOrderDetails(
      {super.key,
      required this.email,
      required this.orderId,
      required this.userName});

  @override
  State<CustomerOrderDetails> createState() => _CustomerOrderDetailsState();
  final String email;
  final String orderId;
  final String userName;
}

bool isLoading = false;
bool isLoading2 = false;
int canceledItemCount = 0;
bool countEnabled = true;
String result = "";
final TextEditingController cancelNote = TextEditingController();

class _CustomerOrderDetailsState extends State<CustomerOrderDetails> {
  @override
  void initState() {
    super.initState();
    var orderNotifier = context.read<OrderNotifier>();
    var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
    var ratingNotifier = context.read<RatingNotifier>();
    ratingNotifier.fetchRatingsData();
    orderNotifier.fetchOrderData();
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
              ratingArea(context),
              orderStatus(),
              orderDetails(context),
              listOrderDetails(),
            ],
          ),
        ),
      ),
    );
  }

  //Bottom for change order status

  Column orderStatus() {
    var orderNotifier = context.watch<OrderNotifier>();
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
                            onPressed: () {
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

  Widget ratingArea(BuildContext context) {
    int selection = 0;
    var orderNotifier = context.watch<OrderNotifier>();
    var ratingNotifier = context.watch<RatingNotifier>();
    selection = ratingNotifier.ratings
            .where((r) => r.orderId == widget.orderId)
            .isNotEmpty
        ? ratingNotifier.ratings
            .where((r) => r.orderId == widget.orderId)
            .first
            .ratingPoint
        : 0;
    return orderNotifier.order
                    .where((o) => o.orderId == widget.orderId)
                    .first
                    .orderStatus ==
                4 &&
            ratingNotifier.ratings
                .where((r) => r.orderId == widget.orderId)
                .isEmpty
        ? SizedBox(
            height: 50,
            child: ElevatedButton(
                onPressed: () async {
                  final String userEmail = await getUserData(0);
                  await showDataAlert(
                      orderNotifier.order
                          .where((o) => o.orderId == widget.orderId)
                          .first
                          .storeEmail,
                      userEmail,
                      widget.orderId);
                  await orderNotifier.fetchOrderData();
                  await ratingNotifier.fetchRatingsData();

                  setState(() {});
                },
                child: const Center(
                  child: Text(
                    'Add Review',
                    style: TextStyle(fontSize: 18),
                  ),
                )),
          )
        : orderNotifier.order
                        .where((o) => o.orderId == widget.orderId)
                        .first
                        .orderStatus ==
                    4 &&
                ratingNotifier.ratings
                    .where((r) => r.orderId == widget.orderId)
                    .isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 3.0, top: 20),
                    child: Text(
                      "Review",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                selection > 0 && selection < 6
                                    ? const Icon(Icons.star,
                                        size: 30,
                                        color: Color.fromARGB(255, 182, 165, 9))
                                    : const Icon(
                                        Icons.star_border,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                selection > 1 && selection < 6
                                    ? const Icon(
                                        Icons.star,
                                        size: 30,
                                        color: Color.fromARGB(255, 182, 165, 9),
                                      )
                                    : const Icon(
                                        Icons.star_border,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                selection > 2 && selection < 6
                                    ? const Icon(
                                        Icons.star,
                                        size: 30,
                                        color: Color.fromARGB(255, 182, 165, 9),
                                      )
                                    : const Icon(
                                        Icons.star_border,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                selection > 3 && selection < 6
                                    ? const Icon(
                                        Icons.star,
                                        size: 30,
                                        color: Color.fromARGB(255, 182, 165, 9),
                                      )
                                    : const Icon(
                                        Icons.star_border,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                selection > 4 && selection < 6
                                    ? const Icon(
                                        Icons.star,
                                        size: 30,
                                        color: Color.fromARGB(255, 182, 165, 9),
                                      )
                                    : const Icon(
                                        Icons.star_border,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 8),
                              child: Divider(
                                height: 1,
                                color: Color.fromARGB(255, 229, 229, 236),
                              ),
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Comment",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(ratingNotifier.ratings
                                    .where((r) => r.orderId == widget.orderId)
                                    .first
                                    .comment)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox();
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

    var orderNotifier = context.watch<OrderNotifier>();
    var orderDetailsNotifier = context.watch<OrderDetailsNotifier>();
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
                borderRadius: BorderRadius.circular(20)),
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
    var orderDetailsNotifier = context.watch<OrderDetailsNotifier>();
    var menuNotifier = context.watch<MenuNotifier>();
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
                color: const Color.fromARGB(255, 249, 241, 246)),
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
                                        .where(
                                            (o) => o.orderId == widget.orderId)
                                        .toList()[index]
                                        .itemCanceled ==
                                    1
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    height: 25,
                                    width: 60,
                                    child:
                                        const Center(child: Text("Canceled")),
                                  )
                                : const SizedBox(),
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

  Future<void> showDataAlert(
      String storeEmail, String userEmail, String orderId) async {
    int selection = 0;
    TextEditingController comment = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
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
                    "Add Review",
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
                width: MediaQuery.of(context).size.width - 80,
                height: 410,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  selection = 1;
                                  setState(() {});
                                },
                                child: selection > 0 && selection < 6
                                    ? const Icon(Icons.star,
                                        size: 50,
                                        color: Color.fromARGB(255, 182, 165, 9))
                                    : const Icon(
                                        Icons.star_border,
                                        size: 50,
                                        color: Colors.black,
                                      )),
                            GestureDetector(
                                onTap: () {
                                  selection = 2;
                                  setState(() {});
                                },
                                child: selection > 1 && selection < 6
                                    ? const Icon(
                                        Icons.star,
                                        size: 50,
                                        color: Color.fromARGB(255, 182, 165, 9),
                                      )
                                    : const Icon(
                                        Icons.star_border,
                                        size: 50,
                                        color: Colors.black,
                                      )),
                            GestureDetector(
                                onTap: () {
                                  selection = 3;
                                  setState(() {});
                                },
                                child: selection > 2 && selection < 6
                                    ? const Icon(
                                        Icons.star,
                                        size: 50,
                                        color: Color.fromARGB(255, 182, 165, 9),
                                      )
                                    : const Icon(
                                        Icons.star_border,
                                        size: 50,
                                        color: Colors.black,
                                      )),
                            GestureDetector(
                                onTap: () {
                                  selection = 4;
                                  setState(() {});
                                },
                                child: selection > 3 && selection < 6
                                    ? const Icon(
                                        Icons.star,
                                        size: 50,
                                        color: Color.fromARGB(255, 182, 165, 9),
                                      )
                                    : const Icon(
                                        Icons.star_border,
                                        size: 50,
                                        color: Colors.black,
                                      )),
                            GestureDetector(
                                onTap: () {
                                  selection = 5;
                                  setState(() {});
                                },
                                child: selection > 4 && selection < 6
                                    ? const Icon(
                                        Icons.star,
                                        size: 50,
                                        color: Color.fromARGB(255, 182, 165, 9),
                                      )
                                    : const Icon(
                                        Icons.star_border,
                                        size: 50,
                                        color: Colors.black,
                                      )),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 200,
                          child: TextField(
                            minLines: 1,
                            maxLines: 5,
                            maxLength: 150,
                            textInputAction: TextInputAction.done,
                            controller: comment,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.black))),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      bool isCompleted = false;
                                      if (selection == 0) {
                                        Dialogs.showErrorDialog(
                                            context, "Please select a point");
                                      } else {
                                        isCompleted = await RatingCreationApi()
                                            .createRating(
                                                context,
                                                storeEmail,
                                                userEmail,
                                                orderId,
                                                selection,
                                                comment.text);
                                      }
                                      if (isCompleted && mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Add')))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
