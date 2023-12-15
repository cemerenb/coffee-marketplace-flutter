import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/pages/login/widgets/company/forgot_password_store_get_email.dart';
import 'package:flutter/material.dart';

class LoginPageAreaCompany extends StatefulWidget {
  const LoginPageAreaCompany({
    super.key,
  });

  @override
  State<LoginPageAreaCompany> createState() => _LoginPageAreaCompanyState();
}

class _LoginPageAreaCompanyState extends State<LoginPageAreaCompany> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: TextField(
            controller: companyEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: TextField(
            obscureText: !isVisible,
            controller: companyPasswordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                filled: true,
                suffixIcon: IconButton(
                  icon: isVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    isVisible = !isVisible;
                    setState(() {});
                  },
                ),
                fillColor: Colors.white,
                hintText: '********',
                hintStyle: const TextStyle(color: Color.fromARGB(99, 0, 0, 0)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(width: 1))),
          ),
        ),
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
                          builder: (context) =>
                              const ForgotPasswordStoreGetEmail(),
                        ));
                  },
                  child: const Text(
                    "Forgot my password",
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  )),
            )
          ],
        ),
      ],
    );
  }
}
