import 'package:coffee/pages/login/login_page.dart';
import 'package:flutter/material.dart';

class LoginUserInputField extends StatefulWidget {
  const LoginUserInputField({
    super.key,
  });

  @override
  State<LoginUserInputField> createState() => _LoginUserInputFieldState();
}

class _LoginUserInputFieldState extends State<LoginUserInputField> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
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
            controller: passwordController,
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
      ],
    );
  }
}
