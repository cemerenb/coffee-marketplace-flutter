import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/pages/login/login_page.dart';
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
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrdersListView()),
                        (route) => false);
                  },
                ),
              ],
            );
          });
    }
  }
}
