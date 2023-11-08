// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CompanyConfirmPasswordField extends StatefulWidget {
  CompanyConfirmPasswordField({
    super.key,
    required this.confirmPasswordController,
  });
  final TextEditingController confirmPasswordController;

  @override
  State<CompanyConfirmPasswordField> createState() =>
      _CompanyConfirmPasswordFieldState();
}

class _CompanyConfirmPasswordFieldState
    extends State<CompanyConfirmPasswordField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 5),
          child: Text(
            "Confirm Password",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextField(
            obscureText: !isVisible,
            controller: widget.confirmPasswordController,
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
