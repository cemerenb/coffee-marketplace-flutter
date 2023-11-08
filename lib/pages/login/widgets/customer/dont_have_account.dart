import 'package:coffee/pages/SignUp/sign_up.dart';
import 'package:flutter/material.dart';

class DontHaveAnAcoountTextButton extends StatelessWidget {
  const DontHaveAnAcoountTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ));
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ))
        ],
      ),
    );
  }
}
