import 'dart:developer';

import 'package:coffee/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class EnterToken extends StatefulWidget {
  const EnterToken({super.key, required this.email});

  @override
  State<EnterToken> createState() => _EnterTokenState();
  final String email;
}

String code = "";

class _EnterTokenState extends State<EnterToken> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(isSwitched: false),
                  ),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Column(
            children: [
              const Text('Enter Reset Token'),
              Text('Reset token sent to ${widget.email}')
            ],
          ),
          VerificationCode(
            onCompleted: (value) {
              code = value;
            },
            onEditing: (value) {},
            itemSize: 50,
            length: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 36, 36, 36),
            ),
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: MaterialButton(
              onPressed: () async {
                log(code);
              },
              child: const Text(
                'Verify Code',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
