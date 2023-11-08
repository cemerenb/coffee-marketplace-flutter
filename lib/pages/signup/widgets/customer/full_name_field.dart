// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FullNameField extends StatelessWidget {
  const FullNameField({
    Key? key,
    required this.fullNameController,
  }) : super(key: key);
  final TextEditingController fullNameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 5),
          child: Text(
            "Full Name",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextField(
            controller: fullNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cem Eren Badur',
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
