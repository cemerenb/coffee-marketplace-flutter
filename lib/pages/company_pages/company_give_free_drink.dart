import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/utils/database_operations/loyalty/update_user_loyalty_points.dart';
import 'package:coffee/utils/database_operations/user/get_user.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/notifiers/loyalty_user.dart';
import 'package:coffee/utils/notifiers/order_notifier.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GiveFreeDrink extends StatefulWidget {
  const GiveFreeDrink({super.key, required this.email});

  @override
  State<GiveFreeDrink> createState() => _GiveFreeDrinkState();
  final String email;
}

String name = "";
int selection = 0;
bool getName = false;

class _GiveFreeDrinkState extends State<GiveFreeDrink> {
  @override
  void initState() {
    var orderNotifier = context.read<OrderNotifier>();
    var pointNotifier = context.read<LoyaltyUserNotifier>();
    orderNotifier.fetchCompanyOrderData();
    pointNotifier.getPoints();
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Give 1 Free Drink"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            userDetails(context),
            const SizedBox(
              height: 40,
            ),
            buttonArea(),
          ],
        ),
      ),
    );
  }

  Container buttonArea() {
    var pointNotifier = context.read<LoyaltyUserNotifier>();
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                blurRadius: 3,
                color: Color.fromARGB(108, 0, 0, 0),
                blurStyle: BlurStyle.outer,
                spreadRadius: 0,
                offset: Offset(1, 2))
          ],
          color: const Color.fromARGB(255, 249, 241, 246),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Confirm Transfer',
            style: TextStyle(fontSize: 30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () async {
                    final storeEmail = await getUserData(0);
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrdersListView(email: storeEmail),
                          ),
                          (route) => false);
                    }
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 50,
                  )),
              IconButton(
                  onPressed: () async {
                    bool isCompleted = false;
                    String response = "";
                    final storeEmail = await getUserData(0);
                    var user = pointNotifier.userPoints
                        .where((p) =>
                            p.userEmail == widget.email &&
                            p.storeEmail == storeEmail)
                        .first;
                    int userPoint = user.totalPoint;
                    int userGained = user.totalGained;
                    if (mounted) {
                      (isCompleted, response) = await UpdateUserPoint()
                          .updateUserPoint(
                              context, widget.email, userPoint, userGained + 1);
                      if (isCompleted) {
                        Dialogs.showTransectionCompleted(
                            context, response, storeEmail);
                      } else {
                        Dialogs.showErrorDialog(
                            context, "An error occured while process");
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.green,
                    size: 50,
                  ))
            ],
          )
        ],
      ),
    );
  }

  Container userDetails(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                blurRadius: 3,
                color: Color.fromARGB(108, 0, 0, 0),
                blurStyle: BlurStyle.outer,
                spreadRadius: 0,
                offset: Offset(1, 2))
          ],
          color: const Color.fromARGB(255, 249, 241, 246),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.email,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 15,
          ),
          getName
              ? Text(
                  name,
                  style: const TextStyle(fontSize: 18),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }

  Future<void> getUserName() async {
    name = await getUser(widget.email);
    getName = true;
    setState(() {});
  }
}
