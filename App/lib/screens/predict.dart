import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy/components/coustom_bottom_nav_bar.dart';
import 'package:pregnancy/components/snackbar.dart';
import 'package:pregnancy/helper/enums.dart';
import 'package:http/http.dart' as http;

class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PredictScreenState createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late String? userId = user?.uid;

  late DateTime userDOB;
  late int age = 20;
  int value1 = 20;
  int value2 = 20;
  int value3 = 20;
  int value4 = 20;
  int value5 = 20;

  String apiResponse = '';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          userDOB = (userDoc.data() as Map)['cdob'].toDate();
          age = calculate(userDOB);
        });
      } else {
        print("User document not found!");
      }
    } catch (e) {
      print("Error retrieving user data: $e");
    }
  }

  int calculate(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  Future<void> callApi(
      int value1, int value2, int value3, int value4, int value5) async {
    // Example API call
    try {
      var url = Uri.parse('http://10.0.2.2:5000/predict');
      var body = {
        "age": age,
        "sbp": value1,
        "dbp": value2,
        "bs": value3,
        "bt": value4,
        "hr": value5
      };

      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        setState(() {
          String input = response.body;
          apiResponse = input.substring(2, input.length - 3);
        });
      } else {
        // ignore: use_build_context_synchronously
        snackBar(context, "Error");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      snackBar(context, "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 253, 227, 238),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: AppBar(
            leading: const BackButton(color: Colors.black),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const Text('Risk Checker',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 0, 85))),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 160),
              IntegerInputField(
                label: 'systolic blood pressure',
                value: value1,
                minValue: 20,
                maxValue: 200,
                onChanged: (newValue) {
                  setState(() {
                    value1 = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              IntegerInputField(
                label: 'diastolic blood pressure',
                value: value2,
                minValue: 20,
                maxValue: 200,
                onChanged: (newValue) {
                  setState(() {
                    value2 = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              IntegerInputField(
                label: 'blood sugar level',
                value: value3,
                minValue: 40,
                maxValue: 200,
                onChanged: (newValue) {
                  setState(() {
                    value3 = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              IntegerInputField(
                label: 'body temperature',
                value: value4,
                minValue: 30,
                maxValue: 50,
                onChanged: (newValue) {
                  setState(() {
                    value4 = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              IntegerInputField(
                label: 'heart rate',
                value: value5,
                minValue: 10,
                maxValue: 200,
                onChanged: (newValue) {
                  setState(() {
                    value5 = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              Container(
                height: 40,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.pink,
                ),
                child: MaterialButton(
                  onPressed: () {
                    callApi(value1, value2, value3, value4, value5);
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Container(
                    height: 60,
                    width: 350,
                    child: Center(
                        child: Text(
                      apiResponse.isNotEmpty
                          ? 'Response: $apiResponse'
                          : 'No Response',
                      style: TextStyle(fontSize: 16),
                    ))),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            const CustomBottomNavBar(selectedMenu: MenuState.predict));
  }
}

class IntegerInputField extends StatelessWidget {
  final String label;
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const IntegerInputField({
    super.key,
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: value.toString(),
            keyboardType: TextInputType.number,
            onChanged: (text) {
              int parsedValue = int.tryParse(text) ?? value;
              if (parsedValue < minValue) {
                parsedValue = minValue;
              } else if (parsedValue > maxValue) {
                parsedValue = maxValue;
              }
              onChanged(parsedValue);
            },
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Color.fromARGB(255, 255, 255, 255),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[500])),
          ),
        ),
      ],
    );
  }
}
