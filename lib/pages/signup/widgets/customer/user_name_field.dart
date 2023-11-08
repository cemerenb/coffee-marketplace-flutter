import 'package:flutter/material.dart';

class UserNameTextField extends StatelessWidget {
  const UserNameTextField({
    super.key,
    required this.userNameController,
  });

  final TextEditingController userNameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 5),
          child: Text(
            "User Name",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextField(
            textInputAction: TextInputAction.next,
            controller: userNameController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'cemerenb',
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
