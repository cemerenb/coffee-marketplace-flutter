import 'dart:developer';

import 'package:coffee/pages/company_pages/company_menu_page.dart';
import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/database_operations/store/get_menu.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

Position? currentPosition;

class Dialogs {
  static Future<void> showErrorDialog(
      BuildContext context, String response) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(response),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  static Future<void> showCompletedDialog(
      BuildContext context, String response) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(response),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(isSwitched: false),
                      ),
                      (route) => false);
                },
              ),
            ],
          );
        });
  }

  static Future<void> showProductCreatedDialog(
      BuildContext context, String response, String email) async {
    final String email = await getUserData(0);
    if (context.mounted) {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(response),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () async {
                    await fetchMenuData();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenusListView(
                                    email: email,
                                  )),
                          (route) => false);
                    }
                  },
                ),
              ],
            );
          });
    }
  }

  static Future<void> showCartPlacedDialog(
      BuildContext context, String response) async {
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position position) {
      currentPosition = position;
    }).catchError((e) {
      log(e.toString());
    });
    if (context.mounted) {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(response),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () async {
                    await fetchMenuData();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoresListView()),
                          (route) => false);
                    }
                  },
                ),
              ],
            );
          });
    }
  }

  void showSheet(context) {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "+905469394850",
    );
    var whatsappUrl =
        "whatsapp://send?phone=+905469394850&text=Hi can you help me?";

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 249, 241, 246),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            // Define padding for the container.
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            // Create a Wrap widget to display the sheet contents.
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Phone Call'),
                  onTap: () {
                    launchUrl(launchUri);
                    Navigator.pop(context);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  leading: Image.asset('assets/img/whatsapp.png',
                      width: 24, height: 24), // Replace with your WhatsApp icon
                  title: const Text('WhatsApp'),
                  onTap: () {
                    try {
                      launchUrl(Uri.parse(whatsappUrl));
                    } catch (e) {
                      //To handle error and display an error message
                      Dialogs.showErrorDialog(context,
                          "An error occurred while launching WhatsApp");
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
