import 'dart:developer';

import 'package:coffee/pages/company_pages/widgets/product_details.dart';
import 'package:coffee/pages/customer_pages/customer_cart.dart';
import 'package:coffee/utils/database_operations/user/update_cart.dart';

import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/notifiers/menu_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notifiers/cart_notifier.dart';
import '../../utils/database_operations/user/add_to_cart.dart';
import '../../utils/notifiers/store_notifier.dart';

class StoreDetails extends StatefulWidget {
  const StoreDetails({super.key, required this.index});

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
  final int index;
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
                Icons.shopping_bag_outlined,
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
                      child: GestureDetector(
                        onTap: () async {
                          final userEmail = await getUserData(0);
                          log(menuItem.menuItemId);
                          if (cartNotifier.cart
                              .where((cart) =>
                                  cart.menuItemId == menuItem.menuItemId)
                              .toList()
                              .isEmpty) {
                            var (bool isCompleted, String responseMessage) =
                                await addToCart(menuItem.storeEmail, userEmail,
                                    menuItem.menuItemId);

                            if (isCompleted && context.mounted) {
                              showSnackbar(context, "Added to cart");
                              context.read<CartNotifier>();
                              setState(() {});
                            } else if (!isCompleted && context.mounted) {
                              showSnackbar(context, responseMessage);
                              setState(() {});
                            }
                          } else {
                            final int itemCount = cartNotifier.cart
                                .where((cart) =>
                                    cart.menuItemId == menuItem.menuItemId &&
                                    cart.storeEmail == menuItem.storeEmail)
                                .toList()[0]
                                .itemCount;
                            if (context.mounted) {
                              var isCompleted = await UpdateCartApi()
                                  .updateCart(context, menuItem.menuItemId,
                                      itemCount + 1);

                              if (isCompleted && context.mounted) {
                                setState(() {
                                  context.read<CartNotifier>().getCart();
                                });
                              }
                            }
                          }
                        },
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.brown.shade400,
                            ),
                            child: Center(
                              child: cartNotifier.cart
                                      .where((cart) =>
                                          cart.menuItemId ==
                                          menuItem.menuItemId)
                                      .toList()
                                      .isEmpty
                                  ? const Icon(Icons.add)
                                  : Text(cartNotifier.cart
                                      .where((cart) =>
                                          cart.menuItemId ==
                                          menuItem.menuItemId)
                                      .toList()[0]
                                      .itemCount
                                      .toString()),
                            )),
                      ))
                ],
              ),
            );
          }
          return const SizedBox();
        }).toList(),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
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
