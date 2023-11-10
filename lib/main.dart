import 'dart:io';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_home_page.dart';
import 'package:coffee/pages/customer_pages/customer_main_page.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/database_operations/login_company.dart';
import 'package:coffee/utils/database_operations/login_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int page = 0;
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
  void initState() {
    super.initState();
    checkUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black, primary: Colors.black),
          useMaterial3: true,
        ),
        home: pageSelector());
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

void checkUser(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final userEmail = prefs.getString('email');
  final userPassword = prefs.getString('password');
  final accountType = prefs.getString('accountType');
  if (userEmail != null) {
    log(userEmail);
  }
  if (userPassword != null) {
    log(userPassword);
  }
  if (accountType != null) {
    log(accountType);
  }
  if (accountType == 'customer' &&
      userEmail != null &&
      userPassword != null &&
      context.mounted) {
    if (await LoginApi().loginUser(context, userEmail, userPassword)) {
      page = 2;
    }
  } else if (accountType == 'company' &&
      userEmail != null &&
      userPassword != null &&
      context.mounted) {
    if (await CompanyLoginApi()
        .loginCompany(context, userEmail, userPassword)) {
      page = 3;
    }
  } else {
    page = 1;
  }
}

Widget pageSelector() {
  if (page == 1) {
    return LoginPage(isSwitched: false);
  } else if (page == 2) {
    return const CustomerHomePage();
  } else {
    return const CompanyHomePage();
  }
}
