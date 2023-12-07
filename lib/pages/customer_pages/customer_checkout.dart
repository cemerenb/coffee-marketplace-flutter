import 'dart:developer';

import 'package:coffee/utils/database_operations/order/create_order.dart';
import 'package:coffee/utils/database_operations/order/create_order_details.dart';
import 'package:coffee/utils/random_string_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/classes/stores.dart';
import '../../utils/database_operations/user/remove_from_cart.dart';
import '../../utils/get_user/get_user_data.dart';
import '../../utils/notifiers/cart_notifier.dart';
import '../../utils/notifiers/store_notifier.dart';
import '../../widgets/dialogs.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage(
      {super.key,
      required this.email,
      required this.storeEmail,
      required this.cartTotal});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
  final String email;
  final String storeEmail;
  final double cartTotal;
}

final TextEditingController orderNote = TextEditingController();

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkoutStoreInfoArea(),
            const Text("Order Note"),
            TextField(
              textInputAction: TextInputAction.done,
              controller: orderNote,
              maxLength: 200,
              maxLines: 7,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 2))),
            )
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(context),
    );
  }

  ClipRRect bottomAppBar(BuildContext context) {
    var cartNotifier = context.read<CartNotifier>();
    var storeNotifier = context.read<StoreNotifier>();
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: BottomAppBar(
        color: Colors.black.withOpacity(0.2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.cartTotal}0 ₺",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 198, 169, 146)),
                onPressed: () async {
                  String orderId = generateRandomHex();
                  int itemCount = 0;
                  for (var i = 0; i < cartNotifier.cart.length; i++) {
                    itemCount += cartNotifier.cart[i].itemCount;
                  }
                  log(itemCount.toString());
                  bool isCompleted = false;
                  bool isCleared = false;
                  bool orderDetailsSent = false;
                  String responseMessage = "";
                  String email = await getUserData(0);
                  if (context.mounted) {
                    (isCompleted, responseMessage) = await CreateOrder()
                        .createOrder(
                            context,
                            storeNotifier.stores
                                .where((store) =>
                                    store.storeEmail == widget.storeEmail)
                                .first
                                .storeEmail,
                            email,
                            orderNote.text,
                            orderId,
                            itemCount,
                            widget.cartTotal);
                  }

                  if (context.mounted) {
                    orderDetailsSent = await createOrderDetails(
                        storeNotifier.stores
                            .where((store) =>
                                store.storeEmail == widget.storeEmail)
                            .first
                            .storeEmail,
                        email,
                        orderId);
                  }

                  isCleared = await removeFromCart(
                      storeNotifier.stores
                          .where(
                              (store) => store.storeEmail == widget.storeEmail)
                          .first
                          .storeEmail,
                      email);
                  if (isCompleted &&
                      isCleared &&
                      context.mounted &&
                      orderDetailsSent) {
                    Dialogs.showCartPlacedDialog(context, responseMessage);
                  }
                },
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40,
                    child: const Center(
                        child: Text(
                      "Complete Order",
                      style: TextStyle(color: Colors.white),
                    ))))
          ],
        ),
      ),
    );
  }

  Future<bool> createOrderDetails(
      String storeEmail, String userEmail, String orderId) async {
    bool isCompleted = false;
    String responseMessage = "";
    var cartNotifier = context.read<CartNotifier>();
    for (var i = 0; i < cartNotifier.cart.length; i++) {
      (isCompleted, responseMessage) = await CreateOrderDetails().createOrder(
          context,
          storeEmail,
          userEmail,
          orderId,
          cartNotifier.cart[i].menuItemId,
          cartNotifier.cart[i].itemCount);
    }
    if (isCompleted && context.mounted) {
      log(responseMessage);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeFromCart(String storeEmail, String userEmail) async {
    var cartNotifier = context.read<CartNotifier>();
    for (var i = 0; i < cartNotifier.cart.length; i++) {
      await DeleteFromCart().deleteFromCart(
          storeEmail, userEmail, cartNotifier.cart[i].menuItemId);
      log(cartNotifier.cart.length.toString());
    }

    if (context.mounted) {
      context.read<CartNotifier>().getCart();
    }
    if (cartNotifier.cart.isEmpty) {
      log("Cart cleared");
      return true;
    } else {
      log("An error occured while cleaning cart");
      return false;
    }
  }

  Padding checkoutStoreInfoArea() {
    var storeNotifier = context.read<StoreNotifier>();
    Iterable<Store> store = storeNotifier.stores
        .where((store) => store.storeEmail == widget.storeEmail);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Card(
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                        height: 90,
                        width: 90,
                        child: Image.network(
                          store.first.storeLogoLink,
                        )),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.first.storeName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "${store.first.openingTime.replaceAll(" ", "")}-${store.first.closingTime.replaceAll(" ", "")}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          size: 16,
                        ),
                        Text("Take-away")
                      ],
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
