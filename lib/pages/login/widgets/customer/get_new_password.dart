import 'package:coffee/pages/login/login_page.dart';
import 'package:coffee/utils/database_operations/forgot_password/change_password_request.dart';
import 'package:coffee/utils/validators.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class GetNewPassword extends StatefulWidget {
  const GetNewPassword({super.key, required this.email, required this.token});

  @override
  State<GetNewPassword> createState() => _GetNewPasswordState();
  final String email;
  final String token;
}

TextEditingController controllerPassword = TextEditingController();
TextEditingController controllerConfirm = TextEditingController();
bool isLoggingIn = false;
bool isVisible = false;
bool isVisible2 = false;

class _GetNewPasswordState extends State<GetNewPassword> {
  @override
  void dispose() {
    controllerPassword.clear();
    controllerConfirm.clear();
    super.dispose();
  }

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Enter your new password',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Password must contain at least one uppercase character, one special character and one number',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  TextField(
                    obscureText: !isVisible,
                    controller: controllerPassword,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: isVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          isVisible = !isVisible;
                          setState(() {});
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      label: const Text('New Password'),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    obscureText: !isVisible2,
                    controller: controllerConfirm,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: isVisible2
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          isVisible2 = !isVisible2;
                          setState(() {});
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      label: const Text('Confirm Password'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 36, 36, 36)),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: isLoggingIn
                      ? const Center(child: CircularProgressIndicator())
                      : MaterialButton(
                          child: const Text(
                            'Change Password',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () async {
                            bool isCompleted = false;
                            // ignore: unused_local_variable
                            String response = "";
                            if (!Validators.minLengthCorrect(
                                controllerPassword.text, 8)) {
                              Dialogs.showErrorDialog(context,
                                  "Password must be at least 8 characters");
                              isLoggingIn = false;
                            } else if (!Validators.uppercasePresent(
                                    controllerPassword.text) ||
                                !Validators.numericsPresent(
                                    controllerPassword.text) ||
                                !Validators.specialCharactersPresent(
                                    controllerPassword.text)) {
                              Dialogs.showErrorDialog(context,
                                  "Password must contain at least one uppercase character, one special character and one number");
                              isLoggingIn = false;
                            } else {
                              if (controllerPassword.text ==
                                  controllerConfirm.text) {
                                setState(() {
                                  isLoggingIn = true;
                                });
                                isLoggingIn = true;
                                (isCompleted, response) =
                                    await ChangeUserPassword().changePassword(
                                        widget.token,
                                        controllerPassword.text,
                                        controllerConfirm.text);
                                if (isCompleted) {
                                  isLoggingIn = false;
                                  await Dialogs.showErrorDialog(context,
                                      "Your password changed successfully");
                                  if (mounted) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LoginPage(isSwitched: false),
                                        ),
                                        (route) => false);
                                  }
                                }
                              } else {
                                Dialogs.showErrorDialog(
                                    context, "Password are not matching");
                              }
                            }
                          },
                        ),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
