import 'package:coffee/pages/company_pages/company_menu_page.dart';
import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/database_operations/store/get_menu.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:flutter/material.dart';

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
}
