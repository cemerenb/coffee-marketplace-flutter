import 'dart:io';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/notifiers/cart_notifier.dart';
import 'package:coffee/utils/notifiers/menu_notifier.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/database_operations/login/login_company.dart';
import 'utils/database_operations/login/login_user.dart';
import 'utils/database_operations/store/get_store_data.dart';

enum PageEnum { loginPage, companyHomePage, customerHomePage }

late String email;
void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartNotifier>(
          create: (_) => CartNotifier(),
        ),
        ChangeNotifierProvider<MenuNotifier>(
          create: (_) => MenuNotifier(),
        ),
        ChangeNotifierProvider<StoreNotifier>(
          create: (_) => StoreNotifier(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
              primary: Colors.black,
            ),
            useMaterial3: true,
          ),
          home: const PageNavigator()),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class PageNavigator extends StatefulWidget {
  const PageNavigator({super.key});

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  PageEnum page = PageEnum.loginPage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkUser(context),
      builder: (context, snapshot) {
        return pageSelector();
      },
    );
  }

  Future<void> checkUser(context) async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('email');
    final userPassword = prefs.getString('password');
    final accountType = prefs.getString('accountType');
    fetchStoreData();
    log(userEmail.toString());
    log(userPassword.toString());
    log(accountType.toString());

    if (accountType == 'customer' &&
        userEmail != null &&
        userPassword != null &&
        context.mounted) {
      if (await LoginApi().loginUser(context, userEmail, userPassword)) {
        page = PageEnum.customerHomePage;
      }
      email = userEmail;
    } else if (accountType == 'company' &&
        userEmail != null &&
        userPassword != null &&
        context.mounted) {
      if (await CompanyLoginApi()
          .loginCompany(context, userEmail, userPassword)) {
        page = PageEnum.companyHomePage;
      }
      email = userEmail;
    } else {
      page = PageEnum.loginPage;
    }
  }

  Widget pageSelector() {
    switch (page) {
      case PageEnum.loginPage:
        return LoginPage(isSwitched: false);

      case PageEnum.customerHomePage:
        return const StoresListView();

      case PageEnum.companyHomePage:
        return const OrdersListView();
    }
  }
}
