import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/default_button.dart';
import '../components/form_error.dart';
import '../components/snackbar.dart';
import '../helper/size_config.dart';

class SignUpTScreen extends StatefulWidget {
  const SignUpTScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpTScreenState createState() => _SignUpTScreenState();
}

class _SignUpTScreenState extends State<SignUpTScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final checkController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  DateTime? selectedDate2 = DateTime.now();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023), // Restrict past dates
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950), // Restrict past dates
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate2 = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
            child: Column(children: [
          Container(height: 140),
          Column(children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.fitHeight)),
            ),
            Text(
              "Register",
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
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: conformPassFormField(),
                  ),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _selectDate2(context);
                        },
                        child: const Text('Select BirthDay'),
                      )),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: const Text('Select Childs BirthDay'),
                      )),
                  FormError(errors: errors),
                  SizedBox(height: getRelativeScreenHeight(10)),
                  DefaultButton(
                    text: "Sign Up",
                    press: () async {
                      User? user;
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        errors = [];
                        setState(() {
                          circular = true;
                        });
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);
                          user = userCredential.user;
                          if (kDebugMode) {
                            print('user created $user');
                          }

                          DocumentReference<Map<String, dynamic>> docRef =
                              FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(user?.uid);

                          await docRef.set({
                            'email': user?.email,
                            'role': "deliver",
                            'dob': selectedDate2,
                            'cdob': selectedDate
                          });
                          // ignore: use_build_context_synchronously
                          snackBar(context, 'User registered successfully');
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(context, '/login');
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            circular = false;
                          });
                          if (e.code == 'weak-password') {
                            // ignore: use_build_context_synchronously
                            snackBar(context, 'Weak password');
                          } else if (e.code == 'email-already-in-use') {
                            // ignore: use_build_context_synchronously
                            snackBar(context,
                                'An acccount already exists for this email!');
                          }
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
                  "Already have an account? ",
                  style: TextStyle(
                      fontSize: getRelativeScreenWidth(16),
                      color: const Color.fromARGB(255, 10, 10, 10)),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Text(
                    "Sign In",
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

  Padding emailFormField() {
    final RegExp emailValidatorRegExp =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Color.fromARGB(255, 2, 2, 2)),
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

  Padding passwordFormField() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          style: const TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
          obscureText: true,
          controller: passwordController,
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: "Please Enter your password");
              return "";
            } else if (value.length < 4) {
              addError(error: 'Password is too short');
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

  Padding conformPassFormField() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          obscureText: true,
          controller: checkController,
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: 'Please Enter your password');
              return "";
            } else if ((passwordController.text != value)) {
              addError(error: "Passwords don't match");
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
              labelText: "Confirm Password",
              hintText: "Re-enter your password",
              hintStyle: TextStyle(color: Colors.grey[500])),
        ));
  }
}
