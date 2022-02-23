import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_application/constants/constant.dart';
import 'package:todo_application/screens/home_screen.dart';
import 'package:todo_application/screens/register_screen.dart';
import 'package:todo_application/widgets/general_text_field.dart';

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
                    textInputAction: TextInputAction.next,
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

                        final user = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        // print(user.user!.email);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      }
                    },
                    child: Text("Login"),
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

                            await FirebaseAuth.instance
                                .signInWithCredential(authProvider);

                            // await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)

                            // navigate to home
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
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

                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
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