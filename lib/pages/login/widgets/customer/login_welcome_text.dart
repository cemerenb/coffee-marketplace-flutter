import 'package:flutter/material.dart';

class LoginWelcomeText extends StatelessWidget {
  const LoginWelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          "Welcome",
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
