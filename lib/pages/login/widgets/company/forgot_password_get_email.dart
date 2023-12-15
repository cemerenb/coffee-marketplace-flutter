import 'package:coffee/pages/login/widgets/company/enter_reset_token.dart';
import 'package:coffee/utils/database_operations/forgot_password/forgot_user_password.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class ForgotPasswordGetEmail extends StatefulWidget {
  const ForgotPasswordGetEmail({super.key});

  @override
  State<ForgotPasswordGetEmail> createState() => _ForgotPasswordGetEmailState();
}

TextEditingController controllerEmail = TextEditingController();

class _ForgotPasswordGetEmailState extends State<ForgotPasswordGetEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controllerEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1)),
                label: const Text('Email'),
              ),
            ),
            const SizedBox(
              height: 30,
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
                  bool isCompleted = false;
                  // ignore: unused_local_variable
                  String response = "";
                  (isCompleted, response) = await ForgotUserPassword()
                      .forgotUserPassword(controllerEmail.text);
                  if (isCompleted) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EnterToken(email: controllerEmail.text),
                        ),
                        (route) => false);
                  } else {
                    Dialogs.showErrorDialog(
                        context, "An error occured while sending email");
                  }
                },
                child: const Text(
                  'Send Email',
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
