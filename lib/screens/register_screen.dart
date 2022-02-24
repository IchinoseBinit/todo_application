import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_application/constants/constant.dart';
import 'package:todo_application/widgets/general_alert_dialog.dart';
import 'package:todo_application/widgets/general_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: basePadding,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Register with email and password",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GeneralTextField(
                  title: "Email",
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your email";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GeneralTextField(
                  title: "Password",
                  controller: passwordController,
                  isObscure: true,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your password";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final emailAddress = emailController.text;
                      final passwordForUser = passwordController.text;

                      // print(email + " " + password);
                      try {
                        GeneralAlertDialog().customLoadingDialog(
                          context,
                        );
                        final user = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailAddress,
                          password: passwordForUser,
                        );
                        // if accurate the code below works
                        Navigator.of(context).pop(); //removes loading indicator
                        Navigator.of(context).pop(); //removes register screen
                        // we reach to login screen
                      } on FirebaseAuthException catch (e) {
                        String message = "";
                        if (e.code == "email-already-in-use") {
                          message = "The email is already used";
                        } else if (e.code == "weak-password") {
                          message =
                              "Your password is too weak. try adding alphanumeric characters";
                        } else if (e.code == "invalid-email") {
                          message = "The email address is invalid";
                        }
                        Navigator.of(context).pop();
                        GeneralAlertDialog()
                            .customAlertDialog(context, message);
                      } catch (ex) {
                        Navigator.of(context).pop();
                        GeneralAlertDialog()
                            .customAlertDialog(context, ex.toString());
                      }
                    }
                  },
                  child: const Text("Register"),
                ),
                // TextButton(onPressed: () {}, child: Text("Register here"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
