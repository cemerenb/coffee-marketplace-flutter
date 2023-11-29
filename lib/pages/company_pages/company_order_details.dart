import 'package:coffee/utils/database_operations/order/cancel_order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notifiers/menu_notifier.dart';
import '../../utils/notifiers/order_details_notifier.dart';
import '../../widgets/dialogs.dart';

class CompanyOrderDetails extends StatefulWidget {
  const CompanyOrderDetails(
      {super.key, required this.email, required this.orderId});

  @override
  State<CompanyOrderDetails> createState() => _CompanyOrderDetailsState();
  final String email;
  final String orderId;
}

final TextEditingController cancelNote = TextEditingController();

class _CompanyOrderDetailsState extends State<CompanyOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Order Details'),
              ),
              listOrderDetails(),
            ],
          ),
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
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: orderDetailsNotifier.orderDetails
                  .where((o) => o.orderId == widget.orderId)
                  .length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      child: Card(
                        child: ListTile(
                          leading: SizedBox(
                            height: 80,
                            width: 80,
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
                              fit: BoxFit.fitHeight,
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
                        ),
                      ),
                    ),
                    Visibility(
                      visible: orderDetailsNotifier
                              .orderDetails[index].itemCanceled ==
                          1,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 10,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(136, 77, 77, 77),
                            borderRadius: BorderRadius.circular(15)),
                        height: 78,
                        child: const Center(
                          child: Text(
                            'Canceled',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: orderDetailsNotifier
                              .orderDetails[index].itemCanceled !=
                          1,
                      child: Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: IconButton(
                            style: IconButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 161, 155)),
                            onPressed: () async {
                              await showDataAlert(index);
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 17,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              })
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
                                          orderDetailsNotifier
                                              .orderDetails[index].storeEmail,
                                          orderDetailsNotifier
                                              .orderDetails[index].menuItemId,
                                          orderDetailsNotifier
                                              .orderDetails[index].orderId,
                                          1,
                                          cancelNote.text);
                                }
                                if (isCompleted) {
                                  setState(() {});
                                  OrderDetailsNotifier()
                                      .fetchOrderDetailsData();
                                  cancelNote.clear();
                                  Navigator.pop(context);
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
