import 'package:coffee/pages/signup/widgets/customer/back_to_sign_in_button.dart';
import 'package:coffee/pages/signup/widgets/customer/confirm_password_field.dart';
import 'package:coffee/pages/signup/widgets/customer/full_name_field.dart';
import 'package:coffee/pages/signup/widgets/customer/password_field.dart';
import 'package:coffee/pages/signup/widgets/customer/email_field.dart';
import 'package:coffee/pages/signup/widgets/customer/user_name_field.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';

import '../../utils/database_operations/register/register_user.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromARGB(255, 150, 150, 150),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 150, 150, 150),
            title: const Text("Sign Up"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  UserNameTextField(userNameController: userNameController),
                  FullNameField(
                    fullNameController: fullNameController,
                  ),
                  EmailField(emailController: emailController),
                  PasswordField(passwordController: passwordController),
                  ConfirmPasswordField(
                      confirmPasswordController: confirmPasswordController),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 36, 36, 36)),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: MaterialButton(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () async {
                        final (success, message) = await RegistrationApi()
                            .registerUser(
                                context,
                                userNameController.text,
                                fullNameController.text,
                                emailController.text,
                                passwordController.text,
                                passwordController.text);

                        if (success && context.mounted) {
                          Dialogs.showCompletedDialog(context, message);
                        } else {
                          Dialogs.showErrorDialog(context, message);
                        }
                      },
                    ),
                  ),
                  const BackToSignInButton()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
