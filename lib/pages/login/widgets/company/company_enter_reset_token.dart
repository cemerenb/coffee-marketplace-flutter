import 'dart:developer';

import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/pages/login/widgets/company/company_get_new_password.dart';
import 'package:coffee/utils/database_operations/forgot_password/check_store_token.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class CompanyEnterToken extends StatefulWidget {
  const CompanyEnterToken({super.key, required this.email});

  @override
  State<CompanyEnterToken> createState() => _CompanyEnterTokenState();
  final String email;
}

String code = "";
bool _onEditing = false;

class _CompanyEnterTokenState extends State<CompanyEnterToken> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(isSwitched: true),
                  ),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text(
                  'Enter Reset Token',
                  style: TextStyle(fontSize: 25),
                ),
                Text('Reset token sent to ${widget.email}'),
                const Text(
                  'Token expires in 5 minutes',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: VerificationCode(
                fillColor: _onEditing
                    ? const Color.fromARGB(255, 243, 198, 195)
                    : Colors.transparent,
                digitsOnly: false,
                fullBorder: true,
                margin: const EdgeInsets.all(1),
                keyboardType: TextInputType.text,
                onCompleted: (String value) {
                  code = value;
                  log(code.toUpperCase());
                },
                onEditing: (bool value) {
                  setState(() {
                    _onEditing = value;
                  });
                  if (!_onEditing) FocusScope.of(context).unfocus();
                },
                itemSize: 50,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                length: 6,
              ),
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
                  if (_onEditing) {
                    setState(() {});
                  } else {
                    bool isCompleted = false;
                    // ignore: unused_local_variable
                    String response = "";
                    (isCompleted, response) = await CheckStoreToken()
                        .checkToken(widget.email, code.toUpperCase());
                    if (isCompleted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreGetNewPassword(
                                email: widget.email, token: code.toUpperCase()),
                          ),
                          (route) => false);
                    } else {
                      Dialogs.showErrorDialog(context, "Token is not correct");
                    }
                  }
                  log(code.toUpperCase());
                  log(_onEditing.toString());
                },
                child: const Text(
                  'Verify Code',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
