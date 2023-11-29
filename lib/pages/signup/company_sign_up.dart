// ignore: unused_import

import 'package:coffee/pages/signup/widgets/company/back_to_sign_in_button_company.dart';
import 'package:coffee/pages/signup/widgets/company/company_confirm_password_field.dart';
import 'package:coffee/pages/signup/widgets/company/company_password_field.dart';
import 'package:coffee/pages/signup/widgets/company/store_name_field.dart';
import 'package:coffee/pages/signup/widgets/company/tax_id_field.dart';
import 'package:coffee/pages/signup/widgets/customer/email_field.dart';
import 'package:coffee/utils/validators.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';

import '../../utils/database_operations/register/register_store.dart';

class CompanySignUp extends StatefulWidget {
  const CompanySignUp({super.key});

  @override
  State<CompanySignUp> createState() => _CompanySignUpState();
}

final TextEditingController storeNameController = TextEditingController();
final TextEditingController taxIdController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

class _CompanySignUpState extends State<CompanySignUp> {
  bool isLoggingIn = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromARGB(255, 150, 150, 150),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 150, 150, 150),
            title: const Text("Create Store"),
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
                  StoreNameField(storeNameController: storeNameController),
                  EmailField(
                    emailController: emailController,
                  ),
                  TaxIdField(taxIdController: taxIdController),
                  CompanyPasswordField(passwordController: passwordController),
                  CompanyConfirmPasswordField(
                      confirmPasswordController: confirmPasswordController),
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
                                'Create Store',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () {
                                if (storeNameController.text.isEmpty) {
                                  Dialogs.showErrorDialog(
                                      context, "Store name can't be empty");
                                  isLoggingIn = false;
                                } else if (Validators.emailValidator(
                                        emailController.text) !=
                                    null) {
                                  Dialogs.showErrorDialog(
                                      context,
                                      Validators.emailValidator(
                                              emailController.text) ??
                                          "");
                                  isLoggingIn = false;
                                } else if (Validators.taxIdValidator(
                                        taxIdController.text) !=
                                    null) {
                                  Dialogs.showErrorDialog(
                                      context,
                                      Validators.taxIdValidator(
                                              taxIdController.text) ??
                                          "");
                                } else if (!Validators.minLengthCorrect(
                                    passwordController.text, 8)) {
                                  Dialogs.showErrorDialog(context,
                                      "Password must be at least 8 characters");
                                  isLoggingIn = false;
                                } else if (!Validators.uppercasePresent(
                                        passwordController.text) ||
                                    !Validators.numericsPresent(
                                        passwordController.text) ||
                                    !Validators.specialCharactersPresent(
                                        passwordController.text)) {
                                  Dialogs.showErrorDialog(context,
                                      "Password must contain at least one uppercase character, one special character and one number");
                                  isLoggingIn = false;
                                } else {
                                  if (passwordController.text ==
                                      confirmPasswordController.text) {
                                    setState(() {
                                      isLoggingIn = true;
                                    });
                                    isLoggingIn = true;
                                    StoreRegistrationApi()
                                        .registerStore(
                                            context,
                                            storeNameController.text,
                                            taxIdController.text,
                                            emailController.text,
                                            passwordController.text,
                                            confirmPasswordController.text)
                                        .then((success) {
                                      setState(() {
                                        storeNameController.text = "";
                                        taxIdController.text = "";
                                        emailController.text = "";
                                        passwordController.text = "";
                                        confirmPasswordController.text = "";
                                        isLoggingIn = false;
                                      });
                                    });
                                  } else {
                                    Dialogs.showErrorDialog(
                                        context, "Password are not matching");
                                  }
                                }
                              },
                            ),
                    ),
                  ),
                  const CompanyBackToSignInButton()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
