import 'dart:developer';

import 'package:coffee/pages/customer_pages/customer_checkout.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/notifiers/cart_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/database_operations/user/remove_from_cart.dart';
import '../../utils/database_operations/user/update_cart.dart';
import '../../utils/notifiers/menu_notifier.dart';
import '../../widgets/dialogs.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartNotifier>().getCart();
    context.read<MenuNotifier>().fetchMenuUserData();
    getTotal();
  }

  String email = "";
  double cartTotal = 0;
  double tempTotal = 0;
  @override
  Widget build(BuildContext context) {
    var cartNotifier = context.watch<CartNotifier>();
    var menuNotifier = context.watch<MenuNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                size: 22,
              ))
        ],
      ),
      body: listCartItems(cartNotifier, menuNotifier),
      bottomNavigationBar: bottomAppBar(context, cartNotifier),
    );
  }

  ClipRRect bottomAppBar(BuildContext context, CartNotifier cartNotifier) {
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
                  "${cartTotal}0 ₺",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade400),
                onPressed: () async {
                  String email = await getUserData(0);
                  if (context.mounted && cartNotifier.cart.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckOutPage(
                              email: email,
                              storeEmail: cartNotifier.cart[0].storeEmail,
                              cartTotal: cartTotal),
                        ));
                  } else if (context.mounted) {
                    Dialogs.showErrorDialog(context, "Cart is empty");
                  }
                },
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40,
                    child: const Center(
                        child: Text(
                      "Checkout",
                      style: TextStyle(color: Colors.white),
                    ))))
          ],
        ),
      ),
    );
  }

  Padding listCartItems(CartNotifier cartNotifier, MenuNotifier menuNotifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cartNotifier.cart.length,
                itemBuilder: (context, index) {
                  var item = menuNotifier.menu.where((menu) =>
                      menu.menuItemId == cartNotifier.cart[index].menuItemId &&
                      menu.storeEmail == cartNotifier.cart[index].storeEmail);

                  return Card(
                    child: ListTile(
                      leading: SizedBox(
                        height: 60,
                        width: 60,
                        child: FadeInImage(
                          placeholder: const AssetImage(
                              'assets/img/placeholder_image.png'),
                          image: NetworkImage(item.first.menuItemImageLink),
                          fit: BoxFit.contain,
                        ),
                      ),
                      title: Text(
                        item.first.menuItemName,
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        '${item.first.menuItemPrice * cartNotifier.cart[index].itemCount}₺',
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: QuantitySelector(
                        itemCount: cartNotifier.cart
                                .where((cart) =>
                                    cart.menuItemId == item.first.menuItemId)
                                .toList()
                                .isNotEmpty
                            ? cartNotifier.cart
                                .where((cart) =>
                                    cart.menuItemId == item.first.menuItemId &&
                                    cart.storeEmail == item.first.storeEmail)
                                .toList()
                                .first
                                .itemCount
                            : 0,
                        isInCart: cartNotifier.cart
                            .where((cart) =>
                                cart.menuItemId == item.first.menuItemId)
                            .toList()
                            .isNotEmpty,
                        onRemoveFromCartPressed: () async {
                          String email = await getUserData(0);
                          await removeFromCart(item.first.storeEmail, email,
                              item.first.menuItemId);

                          await getTotal();
                          setState(() {});
                        },
                        onDecrementPressed: () async {
                          decrementItemCount(
                              item.first.menuItemId,
                              cartNotifier.cart
                                      .where((cart) =>
                                          cart.menuItemId ==
                                              item.first.menuItemId &&
                                          cart.storeEmail ==
                                              item.first.storeEmail)
                                      .toList()[0]
                                      .itemCount -
                                  1);

                          await getTotal();
                          setState(() {});
                        },
                        onIncrementPressed: () async {
                          await incrementItemCount(
                              item.first.menuItemId,
                              cartNotifier.cart
                                      .where((cart) =>
                                          cart.menuItemId ==
                                              item.first.menuItemId &&
                                          cart.storeEmail ==
                                              item.first.storeEmail)
                                      .toList()[0]
                                      .itemCount +
                                  1);

                          await getTotal();
                          setState(() {});
                        },
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Future getTotal() async {
    var cartNotifier = context.read<CartNotifier>();
    var menuNotifier = context.read<MenuNotifier>();
    await cartNotifier.getCart();
    for (var i = 0; i < cartNotifier.cart.length; i++) {
      tempTotal += menuNotifier.menu
              .where(
                  (menu) => menu.menuItemId == cartNotifier.cart[i].menuItemId)
              .first
              .menuItemPrice *
          cartNotifier.cart[i].itemCount;
      log("${menuNotifier.menu.where((menu) => menu.menuItemId == cartNotifier.cart[i].menuItemId).first.menuItemPrice * cartNotifier.cart[i].itemCount}");
    }
    cartTotal = tempTotal;
    tempTotal = 0;
    setState(() {});
  }

  Future<void> incrementItemCount(String menuItemId, int itemCount) async {
    await UpdateCartApi().updateCart(context, menuItemId, itemCount);
    if (context.mounted) {
      context.read<CartNotifier>().getCart();
    }
    await getTotal();
    setState(() {});
  }

  Future<void> decrementItemCount(String menuItemId, int itemCount) async {
    await UpdateCartApi().updateCart(context, menuItemId, itemCount);
    if (context.mounted) {
      context.read<CartNotifier>().getCart();
    }
    await getTotal();
    setState(() {});
  }

  Future<void> removeFromCart(
      String storeEmail, String userEmail, String menuItemId) async {
    await DeleteFromCart().deleteFromCart(storeEmail, userEmail, menuItemId);
    if (context.mounted) {
      context.read<CartNotifier>().getCart();
      showSnackbar(context, "Item deleted from cart");
    }
    await getTotal();
    setState(() {});
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class QuantitySelector extends StatefulWidget {
  final int itemCount;
  final bool isInCart;
  final Function() onRemoveFromCartPressed;
  final Function() onDecrementPressed;
  final Function() onIncrementPressed;

  const QuantitySelector({
    super.key,
    required this.itemCount,
    required this.isInCart,
    required this.onRemoveFromCartPressed,
    required this.onDecrementPressed,
    required this.onIncrementPressed,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 90.0,
        height: 30.0,
        decoration: BoxDecoration(
            color: Colors.brown.shade400,
            borderRadius: BorderRadius.circular(28)),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: widget.itemCount == 1
                  ? IconButton(
                      onPressed: widget.onRemoveFromCartPressed,
                      icon: const Icon(
                        Icons.delete,
                        size: 15,
                      ))
                  : IconButton(
                      onPressed: widget.onDecrementPressed,
                      icon: const Icon(
                        Icons.remove,
                        size: 15,
                      )),
            ),
            SizedBox(
              width: 30,
              child: Center(
                child: Text(widget.itemCount.toString()),
              ),
            ),
            SizedBox(
              width: 30,
              child: IconButton(
                  onPressed: widget.onIncrementPressed,
                  icon: const Icon(
                    Icons.add,
                    size: 15,
                  )),
            )
          ],
        ));
  }
}
