import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/enums.dart';
import 'coustom_bottom_nav_bar.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _nameController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  late String? userId = user?.uid;
    DateTime? selectedDate2 = DateTime.now();
  @override
  void initState() {
    super.initState();
  }


 Future<void> _selectDate2(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950), // Restrict past dates
      lastDate: DateTime(2100),
    );

    if (pickedDate != null ) {
      setState(() {
        selectedDate2 = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:               Color.fromARGB(255, 253, 227, 238),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: AppBar(
            leading: const BackButton(color: Colors.black),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const Text('Event Calendar',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 0, 85))),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Center(
          child: Card(
            elevation: 20,
            shadowColor: Color.fromARGB(255, 187, 187, 187),
            color:  Color.fromARGB(255, 255, 231, 241),
            child: SizedBox(
              width: 300,
              height: 360,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                                   Container(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _selectDate2(context);
                        },
                        child: const Text('Select Date'),
                      )),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _nameController,
                      maxLines: 1,
                      decoration: const InputDecoration(labelText: 'Event'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 40,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        color: Colors.pink,
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          _AddEvent();
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar:
            const CustomBottomNavBar(selectedMenu: MenuState.home));
  }

  // ignore: non_constant_identifier_names
  void _AddEvent() async {
    final name = _nameController.text;
    if (name.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance
        .collection('Event')
        .doc(userId)
        .collection("Data")
        .add({"date": selectedDate2, "name": name});
    if (mounted) {
      Navigator.pushNamed(context, '/cal');
    }
  }
}
