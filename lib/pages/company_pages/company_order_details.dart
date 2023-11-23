import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notifiers/menu_notifier.dart';
import '../../utils/notifiers/order_details_notifier.dart';
import '../../utils/notifiers/order_notifier.dart';

class CompanyOrderDetails extends StatefulWidget {
  const CompanyOrderDetails(
      {super.key, required this.email, required this.orderId});

  @override
  State<CompanyOrderDetails> createState() => _CompanyOrderDetailsState();
  final String email;
  final String orderId;
}

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
    var orderNotifier = context.read<OrderNotifier>();
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
                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.network(
                        menuNotifier.menu
                            .where((m) =>
                                m.menuItemId ==
                                orderDetailsNotifier.orderDetails
                                    .where((o) => o.orderId == widget.orderId)
                                    .toList()[index]
                                    .menuItemId)
                            .first
                            .menuItemImageLink,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    subtitle: Text(orderDetailsNotifier.orderDetails
                        .where((o) => o.orderId == widget.orderId)
                        .toList()[index]
                        .menuItemId),
                  ),
                );
              })
        ],
      ),
    );
  }
}
