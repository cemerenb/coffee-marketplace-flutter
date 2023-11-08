import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  PasswordField({
    super.key,
    required this.passwordController,
  });
  final TextEditingController passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 5),
          child: Text(
            "Password",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextField(
            obscureText: !isVisible,
            textInputAction: TextInputAction.next,
            controller: widget.passwordController,
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
