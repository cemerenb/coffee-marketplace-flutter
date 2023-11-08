import 'package:flutter/material.dart';

class BackToSignInButton extends StatelessWidget {
  const BackToSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
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
