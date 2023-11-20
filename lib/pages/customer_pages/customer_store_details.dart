import 'dart:developer';

import 'package:coffee/pages/company_pages/widgets/product_details.dart';
import 'package:coffee/pages/customer_pages/customer_cart.dart';
import 'package:coffee/utils/database_operations/user/add_to_cart.dart';
import 'package:coffee/utils/database_operations/user/remove_from_cart.dart';
import 'package:coffee/utils/database_operations/user/update_cart.dart';

import 'package:coffee/utils/notifiers/menu_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notifiers/cart_notifier.dart';
import '../../utils/notifiers/store_notifier.dart';

class StoreDetails extends StatefulWidget {
  const StoreDetails({super.key, required this.index, required this.email});

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
  final int index;
  final String email;
}

bool isFound = false;
int category = 1;
int currentIndex = 2;
bool visibility1 = true;
bool visibility2 = false;
bool visibility3 = false;
bool visibility4 = false;
int totalItem = 0;

class _StoreDetailsState extends State<StoreDetails> {
  @override
  void initState() {
    super.initState();
    context.read<CartNotifier>().getCart();

    log("item count ${totalItem.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                if (context.mounted) {
                  await context.read<MenuNotifier>().fetchMenuUserData();
                }
                if (context.mounted) {
                  await context.read<StoreNotifier>().fetchStoreUserData();
                }
                if (context.mounted) {
                  await context.read<CartNotifier>().getCart();
                }

                if (context.mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ));
                }
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 25,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            storeInfoArea(context),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10.0, top: 30, right: 10, left: 10),
              child: Row(
                children: [
                  categoryItem(1),
                  categoryItem(2),
                  categoryItem(3),
                  categoryItem(4),
                  const Spacer(),
                ],
              ),
            ),
            listMenuItems()
          ],
        ),
      ),
    );
  }

  Padding listMenuItems() {
    var cartNotifier = context.watch<CartNotifier>();
    var menuNotifier = context.watch<MenuNotifier>();
    var storeNotifier = context.watch<StoreNotifier>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: menuNotifier.menu.indexed.map((item) {
          var (index, menuItem) = item;
          if (menuItem.storeEmail ==
                  storeNotifier.stores[widget.index].storeEmail &&
              menuItem.menuItemCategory == category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  index: index,
                                  menus: menuNotifier.menu,
                                ),
                              ));
                        },
                        leading: SizedBox(
                          height: 80,
                          width: 80,
                          child: FadeInImage(
                            placeholder: const AssetImage(
                                'assets/img/placeholder_image.png'),
                            image: NetworkImage(menuItem.menuItemImageLink),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        title: Text(menuItem.menuItemName),
                        subtitle: Text(
                          menuItem.menuItemDescription,
                          style: const TextStyle(fontSize: 10),
                        ),
                        trailing: Text(
                          "${menuItem.menuItemPrice} ₺",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: AnimatedQuantitySelector(
                      itemCount: cartNotifier.cart
                              .where((cart) =>
                                  cart.menuItemId == menuItem.menuItemId)
                              .toList()
                              .isNotEmpty
                          ? cartNotifier.cart
                              .where((cart) =>
                                  cart.menuItemId == menuItem.menuItemId &&
                                  cart.storeEmail == menuItem.storeEmail)
                              .toList()[0]
                              .itemCount
                          : 0,
                      isInCart: cartNotifier.cart
                          .where(
                              (cart) => cart.menuItemId == menuItem.menuItemId)
                          .toList()
                          .isNotEmpty,
                      onRemoveFromCartPressed: () async {
                        await removeFromCart(menuItem.storeEmail, widget.email,
                            menuItem.menuItemId);
                        if (context.mounted) {
                          await context.read<CartNotifier>().getCart();
                        }

                        setState(() {});
                      },
                      onDecrementPressed: () async {
                        decrementItemCount(
                            menuItem.menuItemId,
                            cartNotifier.cart
                                    .where((cart) =>
                                        cart.menuItemId ==
                                            menuItem.menuItemId &&
                                        cart.storeEmail == menuItem.storeEmail)
                                    .toList()[0]
                                    .itemCount -
                                1);
                        await context.read<CartNotifier>().getCart();
                        setState(() {});
                      },
                      onIncrementPressed: () async {
                        await incrementItemCount(
                            menuItem.menuItemId,
                            cartNotifier.cart
                                    .where((cart) =>
                                        cart.menuItemId ==
                                            menuItem.menuItemId &&
                                        cart.storeEmail == menuItem.storeEmail)
                                    .toList()[0]
                                    .itemCount +
                                1);
                        if (context.mounted) {
                          await context.read<CartNotifier>().getCart();
                        }
                        setState(() {});
                      },
                      onAddNewPressed: () async {
                        await addToCart(menuItem.storeEmail, widget.email,
                            menuItem.menuItemId);
                        if (context.mounted) {
                          await context.read<CartNotifier>().getCart();
                        }

                        if (context.mounted) {
                          showSnackbar(context, 'Item added to cart');
                        }
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        }).toList(),
      ),
    );
  }

  Future<void> incrementItemCount(String menuItemId, int itemCount) async {
    await UpdateCartApi().updateCart(context, menuItemId, itemCount);
    if (context.mounted) {
      context.read<CartNotifier>().getCart();
    }
    setState(() {});
  }

  Future<void> decrementItemCount(String menuItemId, int itemCount) async {
    await UpdateCartApi().updateCart(context, menuItemId, itemCount);
    if (context.mounted) {
      context.read<CartNotifier>().getCart();
    }
    setState(() {});
  }

  Future<void> removeFromCart(
      String storeEmail, String userEmail, String menuItemId) async {
    await DeleteFromCart().deleteFromCart(storeEmail, userEmail, menuItemId);
    if (context.mounted) {
      context.read<CartNotifier>().getCart();
      showSnackbar(context, "Item deleted from cart");
    }
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

  Padding storeInfoArea(BuildContext context) {
    var storeNotifier = context.watch<StoreNotifier>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10)),
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          height: 80,
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              storeNotifier.stores[widget.index].storeLogoLink,
                              fit: BoxFit.contain,
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              storeNotifier.stores[widget.index].storeName,
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.clip,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
                              children: [
                                Text("-"),
                                Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 216, 196, 19),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20)),
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      size: 18,
                    ),
                    Text(
                      'Take-away',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20)),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Working hours',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 10),
                        ),
                        Text(
                            '${storeNotifier.stores[widget.index].openingTime.replaceAll(" ", "")} - ${storeNotifier.stores[widget.index].closingTime.replaceAll(" ", "")}'),
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  Padding categoryItem(int selectedCategory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: () async {
          category = selectedCategory;
          setVisibility(selectedCategory);
          if (context.mounted) {
            await context.read<MenuNotifier>().fetchMenuUserData();
          }
          setState(() {});
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: category == selectedCategory
                ? Colors.brown.shade400
                : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getCategoryIcon(selectedCategory),
                Visibility(
                  visible: getCategoryVisibility(selectedCategory),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(getCategoryName(selectedCategory)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategoryIcon(int selectedCategory) {
    switch (selectedCategory) {
      case 1:
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset("assets/img/coffee.png"),
        );
      case 2:
        return Image.asset("assets/img/cold-coffee.png");
      case 3:
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Image.asset("assets/img/cake.png"),
        );
      case 4:
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset("assets/img/sandwich.png"),
        );
      default:
        return Image.asset("assets/img/coffee.png");
    }
  }

  String getCategoryName(int selectedCategory) {
    switch (selectedCategory) {
      case 1:
        return "Hot Drinks";
      case 2:
        return "Cold Drinks";
      case 3:
        return "Desserts";
      case 4:
        return "Snacks";
      default:
        return "";
    }
  }

  bool getCategoryVisibility(int selectedCategory) {
    switch (selectedCategory) {
      case 1:
        return visibility1;
      case 2:
        return visibility2;
      case 3:
        return visibility3;
      case 4:
        return visibility4;
      default:
        return false;
    }
  }

  void setVisibility(int selected) {
    visibility1 = selected == 1;
    visibility2 = selected == 2;
    visibility3 = selected == 3;
    visibility4 = selected == 4;
  }
}

class AnimatedQuantitySelector extends StatefulWidget {
  final int itemCount;
  final bool isInCart;
  final Function() onRemoveFromCartPressed;
  final Function() onDecrementPressed;
  final Function() onIncrementPressed;
  final Function() onAddNewPressed;

  const AnimatedQuantitySelector({
    super.key,
    required this.itemCount,
    required this.isInCart,
    required this.onRemoveFromCartPressed,
    required this.onDecrementPressed,
    required this.onIncrementPressed,
    required this.onAddNewPressed,
  });

  @override
  State<AnimatedQuantitySelector> createState() =>
      _AnimatedQuantitySelectorState();
}

class _AnimatedQuantitySelectorState extends State<AnimatedQuantitySelector> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: widget.isInCart ? 90 : 30,
      height: 30.0,
      decoration: BoxDecoration(
          color: Colors.brown.shade400,
          borderRadius: BorderRadius.circular(30)),
      child: widget.isInCart
          ? Visibility(
              visible: widget.isInCart,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: widget.isInCart ? 30 : 0,
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: widget.isInCart ? 30 : 0,
                    child: Center(
                      child: Text(widget.itemCount.toString()),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: widget.isInCart ? 30 : 0,
                    child: IconButton(
                        onPressed: widget.onIncrementPressed,
                        icon: const Icon(
                          Icons.add,
                          size: 15,
                        )),
                  )
                ],
              ),
            )
          : IconButton(
              onPressed: widget.onAddNewPressed,
              icon: const Icon(
                Icons.add,
                size: 15,
              )),
    );
  }
}
