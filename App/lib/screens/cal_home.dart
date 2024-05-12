import 'package:flutter/material.dart';
import 'package:pregnancy/components/add_event.dart';

import '../components/coustom_bottom_nav_bar.dart';
import '../helper/enums.dart';

class CalHome extends StatelessWidget {
  const CalHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const               Color.fromARGB(255, 253, 227, 238),
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
        body: Container(
            child: Center(
          child: Card(
            elevation: 20,
            shadowColor: Color.fromARGB(255, 187, 187, 187),
            color:  Color.fromARGB(255, 255, 231, 241),
            child: SizedBox(
              width: 300,
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    Container(
                      height: 40,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        color: Colors.pink,
                      ),
                      child: MaterialButton(
                        onPressed: () {
                         Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const AddEvent()));
                        },
                        child: const Text(
                          'Add Event',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
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
                        onPressed: () {
                          Navigator.pushNamed(context, '/cal');
                        },
                        child: const Text(
                          'Calendar',
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
        )),
        bottomNavigationBar:
            const CustomBottomNavBar(selectedMenu: MenuState.calandar));
  }
}
