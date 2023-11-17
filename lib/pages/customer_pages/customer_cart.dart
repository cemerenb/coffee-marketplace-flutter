import 'package:coffee/utils/notifiers/cart_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notifiers/menu_notifier.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    var cartNotifier = context.watch<CartNotifier>();
    var menuNotifier = context.watch<MenuNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: cartNotifier.cart.length,
                itemBuilder: (context, index) {
                  var item = menuNotifier.menu.where((menu) =>
                      menu.menuItemId == cartNotifier.cart[index].menuItemId);
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
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: Text(
                        '${item.first.menuItemPrice * cartNotifier.cart[index].itemCount}₺',
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle:
                          Text(cartNotifier.cart[index].itemCount.toString()),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
