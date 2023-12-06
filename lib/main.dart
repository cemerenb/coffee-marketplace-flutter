import 'dart:io';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/notifiers/cart_notifier.dart';
import 'package:coffee/utils/notifiers/loyalty_program_notifier.dart';
import 'package:coffee/utils/notifiers/loyalty_user.dart';
import 'package:coffee/utils/notifiers/menu_notifier.dart';
import 'package:coffee/utils/notifiers/order_details_notifier.dart';
import 'package:coffee/utils/notifiers/order_notifier.dart';
import 'package:coffee/utils/notifiers/rating_notifier.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/database_operations/login/login_company.dart';
import 'utils/database_operations/login/login_user.dart';

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
        ChangeNotifierProvider<OrderNotifier>(
          create: (_) => OrderNotifier(),
        ),
        ChangeNotifierProvider<OrderDetailsNotifier>(
          create: (_) => OrderDetailsNotifier(),
        ),
        ChangeNotifierProvider<RatingNotifier>(
          create: (_) => RatingNotifier(),
        ),
        ChangeNotifierProvider<LoyaltyNotifier>(
            create: (_) => LoyaltyNotifier()),
        ChangeNotifierProvider<LoyaltyUserNotifier>(
            create: (_) => LoyaltyUserNotifier())
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
  Position? currentPosition;
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
    await _handleLocationPermission();
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position position) {
      currentPosition = position;
    }).catchError((e) {
      log(e.toString());
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble("latitude", currentPosition!.latitude.toDouble());
    await prefs.setDouble("longitude", currentPosition!.longitude.toDouble());
    log("latitude : ${prefs.getDouble("latitude")}");
    log("longitude : ${prefs.getDouble("longitude")}");
    final userEmail = prefs.getString('email');
    final userPassword = prefs.getString('password');
    final accountType = prefs.getString('accountType');
    StoreNotifier().fetchStoreUserData();
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

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Widget pageSelector() {
    switch (page) {
      case PageEnum.loginPage:
        return LoginPage(isSwitched: false);

      case PageEnum.customerHomePage:
        return const StoresListView();

      case PageEnum.companyHomePage:
        return OrdersListView(
          email: email,
        );
    }
  }
}
