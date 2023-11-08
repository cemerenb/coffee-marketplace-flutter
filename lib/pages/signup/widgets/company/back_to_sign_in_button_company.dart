import 'package:flutter/material.dart';

class CompanyBackToSignInButton extends StatelessWidget {
  const CompanyBackToSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have a store?",
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Sign In",
              style: TextStyle(color: Colors.brown),
            ))
      ],
    );
  }
}
