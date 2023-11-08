import 'package:coffee/pages/signup/company_sign_up.dart';
import 'package:flutter/material.dart';

class DontHaveAnAcoountTextButtonCompany extends StatelessWidget {
  const DontHaveAnAcoountTextButtonCompany({
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
            "Don't have a store?",
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompanySignUp(),
                    ));
              },
              child: const Text(
                "Create Store",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ))
        ],
      ),
    );
  }
}
