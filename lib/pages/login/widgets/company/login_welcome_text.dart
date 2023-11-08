import 'package:flutter/material.dart';

class LoginWelcomeTextCompany extends StatelessWidget {
  const LoginWelcomeTextCompany({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          "Company Login",
          style: TextStyle(
              fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
      ],
    );
  }
}
