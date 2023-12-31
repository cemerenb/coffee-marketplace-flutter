import 'dart:developer';

import 'package:coffee/pages/company_pages/widgets/product_details.dart';
import 'package:coffee/pages/customer_pages/customer_cart.dart';
import 'package:coffee/pages/customer_pages/customer_reviews_page.dart';
import 'package:coffee/pages/customer_pages/customer_show_qr_code.dart';
import 'package:coffee/utils/database_operations/user/add_to_cart.dart';
import 'package:coffee/utils/database_operations/user/get_user.dart';
import 'package:coffee/utils/database_operations/user/remove_from_cart.dart';
import 'package:coffee/utils/database_operations/user/update_cart.dart';
import 'package:coffee/utils/notifiers/loyalty_program_notifier.dart';
import 'package:coffee/utils/notifiers/loyalty_user.dart';

import 'package:coffee/utils/notifiers/menu_notifier.dart';
import 'package:coffee/utils/notifiers/order_details_notifier.dart';
import 'package:coffee/utils/notifiers/rating_notifier.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notifiers/cart_notifier.dart';
import '../../utils/notifiers/store_notifier.dart';

class StoreDetails extends StatefulWidget {
  const StoreDetails(
      {super.key,
      required this.index,
      required this.email,
      required this.rating,
      required this.storeEmail});

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
  final int index;
  final String email;
  final double rating;
  final String storeEmail;
}

bool isFound = false;
int category = 1;
int currentIndex = 2;
bool visibility1 = true;
bool visibility2 = false;
bool visibility3 = false;
bool visibility4 = false;
int totalItem = 0;
List<String> names = [];

class _StoreDetailsState extends State<StoreDetails> {
  @override
  void initState() {
    super.initState();
    context.read<CartNotifier>().getCart();
    context.read<LoyaltyUserNotifier>().getPoints();
    log(widget.email);
    log(widget.storeEmail);
    log("item count ${totalItem.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    var pointsNotifier = context.read<LoyaltyUserNotifier>();

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
            pointsNotifier.userPoints
                    .where((p) =>
                        p.userEmail == widget.email &&
                        p.storeEmail == widget.storeEmail)
                    .isNotEmpty
                ? loyaltyInfoArea(context)
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
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

  Widget loyaltyInfoArea(BuildContext context) {
    var rulesNotifier = context.read<LoyaltyNotifier>();

    var pointsNotifier = context.read<LoyaltyUserNotifier>();
    // ignore: prefer_typing_uninitialized_variables
    var userPoints;
    var storeLoyalty = rulesNotifier.rules
        .where((s) => s.storeEmail == widget.storeEmail)
        .first;
    if (pointsNotifier.userPoints
        .where((p) =>
            p.userEmail == widget.email && p.storeEmail == widget.storeEmail)
        .isNotEmpty) {
      userPoints = pointsNotifier.userPoints
          .where((p) =>
              p.userEmail == widget.email && p.storeEmail == widget.storeEmail)
          .first;
    }

    double points = ((userPoints.totalPoint -
                (storeLoyalty.pointsToGain * userPoints.totalGained)) %
            storeLoyalty.pointsToGain)
        .toDouble();
    return pointsNotifier.userPoints
            .where((p) =>
                p.userEmail == widget.email &&
                p.storeEmail == widget.storeEmail)
            .isNotEmpty
        ? Stack(children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 14, top: 30),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 249, 241, 246),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 5,
                          color: Color.fromARGB(108, 0, 0, 0),
                          blurStyle: BlurStyle.outer,
                          spreadRadius: 0,
                          offset: Offset(2, 2))
                    ]),
                height: 170,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SizedBox(
                        height: 170,
                        width: 170,
                        child: DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height

                          progress: points,
                          maxProgress: (storeLoyalty.pointsToGain).toDouble(),
                          startAngle: 225,
                          sweepAngle: 270,
                          foregroundColor:
                              const Color.fromARGB(255, 198, 169, 146),
                          backgroundColor: const Color(0xffeeeeee),
                          foregroundStrokeWidth: 15,
                          backgroundStrokeWidth: 15,
                          animation: true,
                          seekSize: 0,
                          seekColor: const Color(0xffeeeeee),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/img/cup.png',
                                scale: 1.2,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  '${points.toInt()}/${storeLoyalty.pointsToGain.toInt()}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          )),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/img/point.png',
                              scale: 2,
                            ),
                            Text(
                              ' ${points.toInt()}',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Text(
                          'Points',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/img/cup.png',
                              scale: 2,
                            ),
                            Text(
                              ' ${((userPoints.totalPoint - (userPoints.totalGained * storeLoyalty.pointsToGain)) / storeLoyalty.pointsToGain).floor().toInt()}',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Text(
                          'Reward',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                right: 20,
                top: 38,
                child: SizedBox(
                  width: 100,
                  height: 30,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (((userPoints.totalPoint -
                                        (userPoints.totalGained *
                                            storeLoyalty.pointsToGain)) /
                                    storeLoyalty.pointsToGain)
                                .floor()
                                .toInt() ==
                            0) {
                          Dialogs.showErrorDialog(
                              context, "You don't have free drink");
                        } else {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerQrCode(
                                    data: "redeempoint:${widget.email}"),
                              ));
                          await pointsNotifier.getPoints();
                          setState(() {});
                        }
                      },
                      child: const Center(child: Text('Redeem'))),
                ))
          ])
        : const SizedBox();
  }

  Column listMenuItems() {
    var cartNotifier = context.read<CartNotifier>();
    var menuNotifier = context.read<MenuNotifier>();
    var storeNotifier = context.read<StoreNotifier>();

    return Column(
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
                  child: cartNotifier.cart.isEmpty ||
                          cartNotifier.cart.first.storeEmail ==
                              menuItem.storeEmail
                      ? AnimatedQuantitySelector(
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
                              .where((cart) =>
                                  cart.menuItemId == menuItem.menuItemId)
                              .toList()
                              .isNotEmpty,
                          onRemoveFromCartPressed: () async {
                            await removeFromCart(menuItem.storeEmail,
                                widget.email, menuItem.menuItemId);
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
                                            cart.storeEmail ==
                                                menuItem.storeEmail)
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
                                            cart.storeEmail ==
                                                menuItem.storeEmail)
                                        .toList()[0]
                                        .itemCount +
                                    1);
                            if (context.mounted) {
                              await context.read<CartNotifier>().getCart();
                            }
                            setState(() {});
                          },
                          onAddNewPressed: () async {
                            if (cartNotifier.cart.isNotEmpty &&
                                cartNotifier.cart.first.storeEmail !=
                                    menuItem.storeEmail) {
                              log("Item store not match with cart items");
                            } else {
                              await addToCart(context, menuItem.storeEmail,
                                  menuItem.menuItemId);
                              if (mounted) {
                                await context.read<CartNotifier>().getCart();
                              }

                              if (context.mounted) {
                                showSnackbar(context, 'Item added to cart');
                              }
                              setState(() {});
                            }
                          },
                        )
                      : const SizedBox(),
                )
              ],
            ),
          );
        }
        return const SizedBox();
      }).toList(),
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
    await DeleteFromCart().deleteFromCart(context, storeEmail, menuItemId);
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
    var storeNotifier = context.read<StoreNotifier>();
    var ratingNotifier = context.read<RatingNotifier>();
    var rateNotifier = context.read<RatingNotifier>();
    var orderDetailsNotifier = context.read<OrderDetailsNotifier>();
    var menuNotifier = context.read<MenuNotifier>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 249, 241, 246),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 5,
                    color: Color.fromARGB(108, 0, 0, 0),
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0,
                    offset: Offset(2, 2))
              ]),
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
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 216, 196, 19),
                                  size: 20,
                                ),
                                Text(
                                  widget.rating.isNaN
                                      ? "-"
                                      : widget.rating.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Divider(
                    height: 1,
                    color: Color.fromARGB(255, 229, 229, 236),
                  ),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Divider(
                    height: 1,
                    color: Color.fromARGB(255, 229, 229, 236),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: SizedBox(
                        height: 30,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 198, 169, 146)),
                            onPressed: () async {
                              await storeNotifier.fetchStoreUserData();
                              await ratingNotifier.fetchRatingsData();
                              await orderDetailsNotifier
                                  .fetchOrderDetailsData();
                              await menuNotifier.fetchMenuUserData();
                              for (var i = 0;
                                  i <
                                      rateNotifier.ratings
                                          .where((r) =>
                                              r.storeEmail == widget.storeEmail)
                                          .length;
                                  i++) {
                                String name = await getUser(rateNotifier.ratings
                                    .where((r) =>
                                        r.storeEmail == widget.storeEmail)
                                    .toList()[i]
                                    .userEmail);
                                names.add(name);
                                log(names.length.toString());
                              }

                              if (mounted) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomerReviews(
                                        storeName: storeNotifier
                                            .stores[widget.index].storeName,
                                        storeEmail: storeNotifier
                                            .stores[widget.index].storeEmail,
                                        nameList: names,
                                      ),
                                    ));
                              }
                            },
                            child: const Center(
                              child: Text('Reviews'),
                            )),
                      ),
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
                ? const Color.fromARGB(255, 198, 169, 146)
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
          color: const Color.fromARGB(255, 198, 169, 146),
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
