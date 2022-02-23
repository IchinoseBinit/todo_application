import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_application/constants/constant.dart';
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

                      final user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailAddress,
                        password: passwordForUser,
                      );
                      Navigator.of(context).pop();
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
