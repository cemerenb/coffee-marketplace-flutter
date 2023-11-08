import 'package:flutter/material.dart';

class CompanyPasswordField extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CompanyPasswordField({
    super.key,
    required this.passwordController,
  });
  final TextEditingController passwordController;

  @override
  State<CompanyPasswordField> createState() => _CompanyPasswordFieldState();
}

class _CompanyPasswordFieldState extends State<CompanyPasswordField> {
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
            textInputAction: TextInputAction.next,
            obscureText: !isVisible,
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
