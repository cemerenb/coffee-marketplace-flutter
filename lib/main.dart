import 'dart:io';
import 'dart:developer';

import 'package:coffee/pages/company_pages/company_home_page.dart';
import 'package:coffee/pages/customer_pages/customer_main_page.dart';
import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/database_operations/login_company.dart';
import 'package:coffee/utils/database_operations/login_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PageEnum { loginPage, companyHomePage, customerHomePage }

PageEnum page = PageEnum.loginPage;
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
    return MaterialApp(
      title: 'Flutter Demo',
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: checkUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return pageSelector();
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
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

Future<void> checkUser(context) async {
  final prefs = await SharedPreferences.getInstance();
  final userEmail = prefs.getString('email');
  final userPassword = prefs.getString('password');
  final accountType = prefs.getString('accountType');

  log(userEmail.toString());
  log(userPassword.toString());
  log(accountType.toString());

  if (accountType == 'customer' &&
      userEmail != null &&
      userPassword != null &&
      context.mounted) {
    if (await LoginApi().loginUser(context, userEmail, userPassword)) {
      page = PageEnum.customerHomePage;
      log(userEmail);
      log(userPassword);
      log(accountType.toString());
    }
  } else if (accountType == 'company' &&
      userEmail != null &&
      userPassword != null &&
      context.mounted) {
    if (await CompanyLoginApi()
        .loginCompany(context, userEmail, userPassword)) {
      page = PageEnum.companyHomePage;
    }
  } else {
    page = PageEnum.loginPage;
  }
}

Widget pageSelector() {
  switch (page) {
    case PageEnum.loginPage:
      return LoginPage(isSwitched: false);

    case PageEnum.customerHomePage:
      return const CustomerHomePage();

    case PageEnum.companyHomePage:
      return CompanyHomePage(
        currentIndex: 1,
      );
  }
}
