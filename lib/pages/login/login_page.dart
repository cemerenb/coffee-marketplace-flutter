import 'dart:ui';

import 'package:coffee/pages/Login/widgets/customer/dont_have_account.dart';
import 'package:coffee/pages/login/widgets/company/dont_have_account.dart';
import 'package:coffee/pages/login/widgets/customer/forgot_password_get_email.dart';
import 'package:coffee/pages/login/widgets/company/login_page_area.dart';
import 'package:coffee/pages/login/widgets/company/login_welcome_text.dart';
import 'package:coffee/pages/login/widgets/customer/login_user_email_field.dart';
import 'package:coffee/pages/login/widgets/customer/login_welcome_text.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';

import 'package:flutter/material.dart';

import '../../utils/database_operations/login/login_company.dart';
import '../../utils/database_operations/login/login_user.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.isSwitched});
  late bool isSwitched;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController companyEmailController = TextEditingController();
final TextEditingController companyPasswordController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    companyEmailController.clear();
    companyPasswordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: !widget.isSwitched
            ? Image.asset(
                "assets/img/bg_login.png",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )
            : Image.asset(
                "assets/img/bg_login_company.png",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              Transform.scale(
                scale: 1.2,
                child: Switch(
                  thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                      (Set<MaterialState> states) {
                    if (!widget.isSwitched) {
                      return const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 20,
                      );
                    } else {
                      return const Icon(
                        Icons.store,
                        size: 20,
                        color: Colors.black,
                      );
                    }
                  }),
                  onChanged: (value) {
                    widget.isSwitched = !widget.isSwitched;
                    setState(() {});
                  },
                  activeColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  inactiveThumbColor: Colors.white,
                  value: widget.isSwitched,
                ),
              ),
            ],
          ),
          body: !widget.isSwitched
              ? const SingleChildScrollView(child: PersonLoginPage())
              : const SingleChildScrollView(
                  child:
                      CompanyLoginPage()), // Remove the 'const' for CompanyLoginPage
        ),
      ),
    ]);
  }
}

class PersonLoginPage extends StatefulWidget {
  const PersonLoginPage({super.key});

  @override
  State<PersonLoginPage> createState() => _PersonLoginPageState();
}

bool rememberMe = false;

class _PersonLoginPageState extends State<PersonLoginPage> {
  bool isLoggingIn = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const LoginWelcomeText(),
        const SizedBox(
          height: 100,
        ),
        const LoginUserInputField(),
        Row(
          children: [
            const Spacer(),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordGetEmail(),
                        ));
                  },
                  child: const Text(
                    "Forgot my password",
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  )),
            )
          ],
        ),
        const SizedBox(
          height: 70,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 36, 36, 36)),
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: isLoggingIn
                ? const Center(child: CircularProgressIndicator())
                : MaterialButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () async {
                      bool isCompleted = false;

                      setState(() {
                        isLoggingIn = true;
                      });

                      await StoreNotifier().fetchStoreUserData();
                      if (mounted) {
                        isCompleted = await LoginApi().loginUser(context,
                            emailController.text, passwordController.text);
                      }
                      isLoggingIn = isCompleted;
                      setState(() {});
                    },
                  ),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        const DontHaveAnAcoountTextButton()
      ],
    );
  }
}

class CompanyLoginPage extends StatefulWidget {
  const CompanyLoginPage({super.key});

  @override
  State<CompanyLoginPage> createState() => _CompanyLoginPageState();
}

class _CompanyLoginPageState extends State<CompanyLoginPage> {
  bool isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const LoginWelcomeTextCompany(),
        const SizedBox(
          height: 100,
        ),
        const LoginPageAreaCompany(),
        const SizedBox(
          height: 70,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 36, 36, 36),
            ),
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: isLoggingIn
                ? const Center(child: CircularProgressIndicator())
                : MaterialButton(
                    onPressed: () async {
                      bool isCompleted = false;

                      setState(() {
                        isLoggingIn = true;
                      });

                      isCompleted = await CompanyLoginApi().loginCompany(
                          context,
                          companyEmailController.text,
                          companyPasswordController.text);
                      if (isCompleted) {
                        await StoreNotifier().fetchStoreUserData();
                      } else {
                        isLoggingIn = false;
                        setState(() {});
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        const DontHaveAnAcoountTextButtonCompany()
      ],
    );
  }
}
