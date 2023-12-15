import 'package:coffee/pages/login/widgets/customer/forgot_password_get_email.dart';
import 'package:flutter/material.dart';

import '../../login_page.dart';

class LoginPageArea extends StatelessWidget {
  const LoginPageArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: TextField(
            controller: emailController,
            onEditingComplete: () {},
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1))),
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1))),
        ),
        Row(
          children: [
            const Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordGetEmail(),
                      ));
                },
                child: const Text("Forgot my password"))
          ],
        ),
      ],
    );
  }
}
