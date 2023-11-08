// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TaxIdField extends StatelessWidget {
  const TaxIdField({
    Key? key,
    required this.taxIdController,
  }) : super(key: key);
  final TextEditingController taxIdController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 5),
          child: Text(
            "Tax Id",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextField(
            controller: taxIdController,
            keyboardType: TextInputType.number,
            maxLength: 11,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: '23912832981',
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
