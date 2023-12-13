import 'dart:math';

import 'package:coffee/pages/company_pages/company_give_free_drink.dart';
import 'package:coffee/utils/database_operations/user/get_user.dart';
import 'package:coffee/utils/notifiers/menu_notifier.dart';
import 'package:coffee/utils/notifiers/order_details_notifier.dart';
import 'package:coffee/utils/notifiers/order_notifier.dart';
import 'package:coffee/utils/notifiers/rating_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerReviews extends StatefulWidget {
  final List<String> nameList;
  const CustomerReviews(
      {super.key,
      required this.storeName,
      required this.storeEmail,
      required this.nameList});
  final String storeName;
  final String storeEmail;

  @override
  State<CustomerReviews> createState() => _CustomerReviewsState();
}

bool isNameLoading = false;

class _CustomerReviewsState extends State<CustomerReviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storeName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [listReviews()],
          ),
        ),
      ),
    );
  }

  ListView listReviews() {
    var rateNotifier = context.read<RatingNotifier>();
    var orderNotifier = context.read<OrderNotifier>();
    var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
    var menuNotifier = context.read<MenuNotifier>();
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: rateNotifier.ratings
          .where((r) => r.storeEmail == widget.storeEmail)
          .length,
      itemBuilder: (context, index) {
        var rate = rateNotifier.ratings
            .where((r) => r.storeEmail == widget.storeEmail)
            .toList();
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 150, 150, 150)
                        .withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(3, 3), // changes position of shadow
                  ),
                ],
                color: const Color.fromARGB(255, 249, 241, 246),
                borderRadius: BorderRadius.circular(15)),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          isNameLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Text(
                                  widget.nameList[index],
                                  style: const TextStyle(fontSize: 18),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 216, 196, 19),
                            size: 25,
                          ),
                          Text(
                            rate[index].ratingPoint.toString(),
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      Text(rate[index]
                          .ratingDate
                          .split("t")
                          .first
                          .replaceAll(" ", "/"))
                    ],
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
                    child: Divider(
                      height: 1,
                      color: Color.fromARGB(59, 0, 0, 0),
                    ),
                  ),
                  Text(rate[index].comment),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
                    child: Divider(
                      height: 1,
                      color: Color.fromARGB(59, 0, 0, 0),
                    ),
                  ),
                  Wrap(
                    children: List.generate(
                      orderDetailsNotifier.orderDetails
                          .where((o) => o.orderId == rate[index].orderId)
                          .length,
                      (innerIndex) => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                            "${orderDetailsNotifier.orderDetails.where((o) => o.orderId == rate[index].orderId).toList()[innerIndex].itemCount} x ${menuNotifier.menu.where((m) => m.menuItemId == orderDetailsNotifier.orderDetails.where((o) => o.orderId == rate[index].orderId).toList()[innerIndex].menuItemId).first.menuItemName},"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
