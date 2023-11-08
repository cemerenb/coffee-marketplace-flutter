import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.emailController,
  });
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 5),
          child: Text(
            "Email",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'example@example.com',
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
