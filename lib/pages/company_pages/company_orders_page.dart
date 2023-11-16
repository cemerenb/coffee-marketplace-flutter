import 'package:coffee/pages/company_pages/company_menu_page.dart';
import 'package:coffee/pages/company_pages/company_settings.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:flutter/material.dart';

import '../../utils/database_operations/store/get_store_data.dart';

class OrdersListView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const OrdersListView({
    super.key,
  });

  @override
  State<OrdersListView> createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<OrdersListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('Order Page'),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Padding bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 88, 88, 88).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20)),
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.list,
                            size: 30, color: Colors.brown.shade600),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.brown.shade600),
                        )
                      ],
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      final String email = await getUserData(0);
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenusListView(email: email),
                            ));
                        setState(() {});
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.coffee, size: 25, color: Colors.black),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent),
                        )
                      ],
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      final String email = await getUserData(0);
                      await fetchStoreData();
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreInfoPage(email: email),
                            ));
                        setState(() {});
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.settings,
                            size: 25, color: Colors.black),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent),
                        )
                      ],
                    )),
              ]),
        ),
      ),
    );
  }
}
