// store_info_page.dart

import 'package:coffee/main.dart';
import 'package:coffee/pages/company_pages/widgets/complete_store_account.dart';
import 'package:flutter/material.dart';
import '../../utils/classes/stores.dart';

class StoreInfoPage extends StatefulWidget {
  final List<Store> store;
  final String email;

  const StoreInfoPage({Key? key, required this.store, required this.email})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StoreInfoPageState createState() => _StoreInfoPageState();
}

class _StoreInfoPageState extends State<StoreInfoPage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.store[0].storeLogoLink.isEmpty
        ? AccountNotCompleted(
            widget: widget,
            email: email,
          )
        : const Column(
            children: [
              Text('StoreCompleted'),
            ],
          );
  }
}

class AccountNotCompleted extends StatelessWidget {
  const AccountNotCompleted(
      {super.key, required this.widget, required this.email});

  final StoreInfoPage widget;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    top: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome ",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        widget.store[0].storeName,
                        style: const TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Your account not completed yet"),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompleteAccount(
                                      store: widget.store, email: email),
                                ));
                          },
                          icon: const Icon(
                            Icons.arrow_right_alt,
                            size: 35,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
