import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy/components/coustom_bottom_nav_bar.dart';
import 'package:pregnancy/helper/enums.dart';

class HomeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late String? userId = user?.uid;
  
  late DateTime userDOB;
  late int weeksDifference=1;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        setState(() {
          userDOB = (userDoc.data() as Map)['cdob'].toDate();
          weeksDifference = calculateWeeksDifference(userDOB);
        });
      } else {
        print("User document not found!");
      }
    } catch (e) {
      print("Error retrieving user data: $e");
    }
  }

  int calculateWeeksDifference(DateTime dob) {
    DateTime now = DateTime.now();
    int differenceInDays = now.difference(dob).inDays;
    int differenceInWeeks = (differenceInDays / 7).floor();
    return differenceInWeeks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const               Color.fromARGB(255, 253, 227, 238),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: AppBar(
            leading: const BackButton(color: Colors.black),
            backgroundColor: Colors.transparent,
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/top.png',
              width: 120,
            ),
          ),
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Image.asset('assets/images/$weeksDifference.PNG'),
                const SizedBox(height: 20),
               Text(
                  "Week $weeksDifference",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                 Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '$weeksDifference week of pregnancy, you will be able to see your baby\'s growth and feeding status.',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        )
              ]))
        ]),
        bottomNavigationBar:
            const CustomBottomNavBar(selectedMenu: MenuState.home));
  }
}
