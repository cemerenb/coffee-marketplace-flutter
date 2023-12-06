// store_info_page.dart

import 'dart:developer';

import 'package:coffee/main.dart';
import 'package:coffee/pages/company_pages/company_loyalty_settings.dart';
import 'package:coffee/pages/company_pages/company_menu_page.dart';
import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/pages/company_pages/widgets/add_logo.dart';
import 'package:coffee/utils/database_operations/store/get_menu.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/log_out/log_out.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../utils/database_operations/store/toggle_store.dart';

class StoreInfoPage extends StatefulWidget {
  final String email;

  const StoreInfoPage({Key? key, required this.email}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StoreInfoPageState createState() => _StoreInfoPageState();
}

int currentIndex = 3;

class _StoreInfoPageState extends State<StoreInfoPage> {
  @override
  void initState() {
    var storeNotifier = context.read<StoreNotifier>();
    storeNotifier.fetchStoreUserData();
    storeNotifier.fetchStoreUserData();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = false;
    String responseMessage = "";
    return Scaffold(
      body: settingsPage(context, isCompleted, responseMessage),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget settingsPage(
      BuildContext context, bool isCompleted, String responseMessage) {
    var storeNotifier = context.watch<StoreNotifier>();
    return storeNotifier.stores
            .where((s) => s.storeEmail == widget.email)
            .first
            .storeLogoLink
            .isEmpty
        ? AccountNotCompleted(
            widget: widget,
            email: email,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  LogoArea(
                    widget: widget,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: GoogleMap(
                                zoomControlsEnabled: false,
                                markers: <Marker>{
                                  Marker(
                                    markerId: const MarkerId("1"),
                                    icon: BitmapDescriptor.defaultMarker,
                                    position: LatLng(
                                        storeNotifier.stores
                                            .where((s) =>
                                                s.storeEmail == widget.email)
                                            .first
                                            .storeLatitude
                                            .toDouble(),
                                        storeNotifier.stores
                                            .where((s) =>
                                                s.storeEmail == widget.email)
                                            .first
                                            .storeLongitude
                                            .toDouble()),
                                  )
                                },
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        storeNotifier.stores
                                            .where((s) =>
                                                s.storeEmail == widget.email)
                                            .first
                                            .storeLatitude
                                            .toDouble(),
                                        storeNotifier.stores
                                            .where((s) =>
                                                s.storeEmail == widget.email)
                                            .first
                                            .storeLongitude
                                            .toDouble()),
                                    zoom: 16)),
                          ),
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        toggleStoreIsOnArea(
                            context, isCompleted, responseMessage),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.3,
                          height: 170,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15)),
                          child: IconButton(
                              onPressed: () {
                                logOut(context);
                                setState(() {});
                              },
                              icon: const Icon(Icons.logout_outlined)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 170,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15)),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CompanyLoyaltySettings(
                                              email: widget.email),
                                    ));
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Loyalty Program",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text(
                                      "Settings",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Container toggleStoreIsOnArea(
      BuildContext context, bool isCompleted, String responseMessage) {
    var storeNotifier = context.watch<StoreNotifier>();
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      height: 170,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Store',
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
                Switch(
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                  activeColor: const Color.fromARGB(255, 13, 104, 16),
                  value: storeNotifier.stores
                          .where((s) => s.storeEmail == widget.email)
                          .first
                          .storeIsOn ==
                      1,
                  onChanged: (value) async {
                    if (storeNotifier.stores
                            .where((s) => s.storeEmail == widget.email)
                            .first
                            .storeIsOn ==
                        1) {
                      (isCompleted, responseMessage) = await ToggleStoreStatus()
                          .toggleStoreStatus(
                              context,
                              storeNotifier.stores
                                  .where((s) => s.storeEmail == widget.email)
                                  .first
                                  .storeEmail,
                              0);
                      log(isCompleted.toString());
                      log(responseMessage);
                      await storeNotifier.fetchStoreUserData();
                      setState(() {});
                    } else {
                      (isCompleted, responseMessage) = await ToggleStoreStatus()
                          .toggleStoreStatus(
                              context,
                              storeNotifier.stores
                                  .where((s) => s.storeEmail == widget.email)
                                  .first
                                  .storeEmail,
                              1);
                      await storeNotifier.fetchStoreUserData();
                      log(isCompleted.toString());
                      log(responseMessage);
                      setState(() {});
                    }
                  },
                )
              ],
            ),
            Text(
              storeNotifier.stores
                          .where((s) => s.storeEmail == widget.email)
                          .first
                          .storeIsOn ==
                      1
                  ? 'Open'
                  : 'Close',
              style: TextStyle(
                  color: storeNotifier.stores
                              .where((s) => s.storeEmail == widget.email)
                              .first
                              .storeIsOn ==
                          1
                      ? Colors.green
                      : Colors.red,
                  fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }

  Padding bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 1),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrdersListView(
                              email: widget.email,
                            ),
                          ));
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.list, size: 25, color: Colors.black),
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
                      await fetchMenuData();
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenusListView(email: email),
                            ));
                      }

                      setState(() {});
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
                      context.read<StoreNotifier>();
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.settings,
                            size: 30,
                            color: Color.fromARGB(255, 198, 169, 146)),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 198, 169, 146)),
                        )
                      ],
                    )),
              ]),
        ),
      ),
    );
  }
}

class LogoArea extends StatelessWidget {
  const LogoArea({
    super.key,
    required this.widget,
  });

  final StoreInfoPage widget;

  @override
  Widget build(BuildContext context) {
    var storeNotifier = context.watch<StoreNotifier>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.network(
              storeNotifier.stores
                  .where((s) => s.storeEmail == widget.email)
                  .first
                  .storeLogoLink,
              height: 130,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Welcome back!',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300)),
                      Text(
                        storeNotifier.stores
                            .where((s) => s.storeEmail == widget.email)
                            .first
                            .storeName,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_right_alt,
                          size: 35,
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
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
    var storeNotifier = context.watch<StoreNotifier>();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome ",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          storeNotifier.stores
                              .where((s) => s.storeEmail == widget.email)
                              .first
                              .storeName,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 25),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                                    builder: (context) =>
                                        AddLogo(email: email)));
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
