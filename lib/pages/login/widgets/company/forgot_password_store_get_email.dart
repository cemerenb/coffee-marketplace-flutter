import 'package:flutter/material.dart';

class ForgotPasswordStoreGetEmail extends StatefulWidget {
  const ForgotPasswordStoreGetEmail({super.key});

  @override
  State<ForgotPasswordStoreGetEmail> createState() =>
      _ForgotPasswordStoreGetEmailState();
}

TextEditingController emailController = TextEditingController();

class _ForgotPasswordStoreGetEmailState
    extends State<ForgotPasswordStoreGetEmail> {
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
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1)),
                label: const Text('Email'),
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
                onPressed: () {},
                child: const Text(
                  'Send Email',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
