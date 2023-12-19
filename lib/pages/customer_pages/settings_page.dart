import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:coffee/utils/log_out/log_out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/notifiers/store_notifier.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
            onPressed: () {
              logOut(context, false);
            },
            icon: const Icon(Icons.logout)),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Padding bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10.0,
        left: 10,
        right: 10,
      ),
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
                  if (context.mounted) {
                    await context.read<StoreNotifier>().fetchStoreUserData();
                  }
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StoresListView(),
                        ),
                        (route) => false);
                    setState(() {});
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.home_outlined,
                        size: 25, color: Colors.black),
                    Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shadowColor: Colors.transparent),
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        size: 25, color: Colors.black),
                    Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shadowColor: Colors.transparent),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ),
                      (route) => false);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.settings_outlined,
                        size: 25, color: Color.fromARGB(255, 198, 169, 146)),
                    Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 198, 169, 146)),
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
