import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/constants/constant.dart';
import '/screens/home_screen.dart';
import '/screens/register_screen.dart';
import '/widgets/general_alert_dialog.dart';
import '/widgets/general_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: basePadding,
          child: SingleChildScrollView(
              child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_to_queue_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.headline5,
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
                        return "Please enter your email address";
                      }
                      return null;
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
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final email = emailController.text;
                        final password = passwordController.text;
                        try {
                          GeneralAlertDialog().customLoadingDialog(context);
                          // continue
                          final user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          // print(user.user!.uid);
                          // if accurate then the code below works
                          Navigator.of(context).pop();

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(user.user!.uid),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          String message = "";
                          if (e.code == "user-not-found") {
                            message = "The user does not exist";
                          } else if (e.code == "too-many-requests") {
                            message =
                                "Your account is locked, please try again later.";
                          } else if (e.code == "wrong-password") {
                            message = "Incorrect password";
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
                    child: const Text("Login"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // call signIn method of google sign in
                          final googleSignIn = GoogleSignIn();
                          final user = await googleSignIn.signIn();
                          if (user != null) {
                            final authenticatedUser = await user.authentication;

                            // add to firebase

                            // authenticatedUser.

                            final authProvider = GoogleAuthProvider.credential(
                              idToken: authenticatedUser.idToken,
                              accessToken: authenticatedUser.accessToken,
                            );

                            final userCredential = await FirebaseAuth.instance
                                .signInWithCredential(authProvider);

                            // print(userCredential.user!.uid);

                            // await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)

                            // navigate to home
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (_) =>
                                  HomeScreen(userCredential.user!.uid),
                            ));
                          }
                        },
                        child: CachedNetworkImage(
                          imageUrl: ImageConstants.googleImageUrl,
                          width: 50,
                          placeholder: (_, __) => const SizedBox(
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final user =
                              await FirebaseAuth.instance.signInAnonymously();

                          // print(user.user!.uid);

                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (_) => HomeScreen(user.user!.uid),
                          ));
                        },
                        child: Text(
                          "Login as Guest",
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Or,"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => RegisterScreen()));
                        },
                        child: Text("Register"),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
