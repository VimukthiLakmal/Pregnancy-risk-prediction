import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/form_error.dart';
import '../components/snackbar.dart';

import '../../../components/default_button.dart';
import '../../helper/size_config.dart';

import 'package:firebase_auth/firebase_auth.dart';

class KeyboardUtil {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  List<String?> errors = [];
  bool circular = false;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
            child: Column(children: [
          Container(height: 190),
          Column(children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.fitHeight)),
            ),
            Text(
              "Login",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: getRelativeScreenWidth(28),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: emailFormField(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: passwordFormField(),
                  ),
                  FormError(errors: errors),
                  SizedBox(height: getRelativeScreenHeight(10)),
                  DefaultButton(
                    text: "Login",
                    press: () async {
                      if (_formKey.currentState!.validate()) {
                        User? user;
                        _formKey.currentState!.save();
                        KeyboardUtil.hideKeyboard(context);
                        errors = [];
                        setState(() {
                          circular = true;
                        });
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          setState(() {
                            circular = false;
                          });
                          if (!mounted) return;

                          user = userCredential.user;

                          DocumentSnapshot userDoc = await FirebaseFirestore
                              .instance
                              .collection('user')
                              .doc(user?.uid)
                              .get();

                          if (userDoc.exists) {
                            // Extract user data
                            Map<String, dynamic> userData =
                                userDoc.data() as Map<String, dynamic>;

                            // Check user role
                            if (userData['role'] == 'pregnent') {
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(context, '/home');
                            } else {
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(context, '/home');
                            }
                          } else {
                            // ignore: use_build_context_synchronously
                            snackBar(context, 'error.');
                          }
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            circular = false;
                          });
                          if (e.code == 'user-not-found') {
                            // ignore: use_build_context_synchronously
                            snackBar(context, 'No user found for this email.');
                          } else if (e.code == 'wrong-password') {
                            // ignore: use_build_context_synchronously
                            snackBar(context, 'Invalid password.');
                          }
                          else{           snackBar(context, 'Error');}
                  
                          
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  circular ? const CircularProgressIndicator() : const Text(''),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t have an account? ",
                  style: TextStyle(
                      fontSize: getRelativeScreenWidth(16),
                      color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/select'),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: getRelativeScreenWidth(16),
                        color: const Color.fromARGB(255, 236, 64, 121)),
                  ),
                ),
              ],
            ),
          ]),
        ])));
  }

  Padding passwordFormField() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          obscureText: true,
          style: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
          controller: passwordController,
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: 'Please Enter your password');
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              filled: true,
              labelText: "Password",
              hintText: "Enter your password",
              hintStyle: TextStyle(color: Colors.grey[500])),
        ));
  }

  Padding emailFormField() {
    final RegExp emailValidatorRegExp =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: 'Please Enter your email');
              return "";
            } else if (!emailValidatorRegExp.hasMatch(value)) {
              addError(error: 'Please Enter Valid Email');
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              filled: true,
              labelText: "Email",
              hintText: "Enter email",
              hintStyle: TextStyle(color: Colors.grey[500])),
        ));
  }
}
