import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/data.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/coustom_bottom_nav_bar.dart';
import '../components/item.dart';
import '../helper/enums.dart';

class Cal extends StatefulWidget {
  const Cal({super.key});

  @override
  State<Cal> createState() => _CalState();
}

class _CalState extends State<Cal> {
  User? user = FirebaseAuth.instance.currentUser;
  late String? userId = user?.uid;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Data>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('Event')
        .doc(userId)
        .collection("Data")
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
            fromFirestore: Data.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
      final day =
          DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  List<Data> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 233, 247, 250),
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
            child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [
                      0.2,
                      0.5,
                      0.8,
                      0.7
                    ],
                        colors: [
                      Color.fromARGB(255, 253, 227, 238),
                       Color.fromARGB(255, 253, 227, 238),
                       Color.fromARGB(255, 253, 227, 238),
          Color.fromARGB(255, 253, 227, 238),
                    ])),
                child: ListView(
                  children: [
                      const SizedBox(height: 100),
                    TableCalendar(
                      eventLoader: _getEventsForTheDay,
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      focusedDay: _focusedDay,
                      firstDay: _firstDay,
                      lastDay: _lastDay,
                      onPageChanged: (focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                        _loadFirestoreEvents();
                      },
                      selectedDayPredicate: (day) =>
                          isSameDay(day, _selectedDay),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarStyle: const CalendarStyle(
                        weekendTextStyle: TextStyle(
                          color: Colors.red,
                        ),
                        selectedDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.red,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        headerTitleBuilder: (context, day) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(day.toString()),
                          );
                        },
                      ),
                    ),
                    ..._getEventsForTheDay(_selectedDay).map(
                      (event) => EventItem(
                          event: event,
                          onDelete: () async {
                            final delete = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Delete Event?"),
                                content: const Text(
                                    "Are you sure you want to delete?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black,
                                    ),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                            if (delete ?? false) {
                              await FirebaseFirestore.instance
                                  .collection('Event')
                                  .doc(userId)
                                  .collection("Data")
                                  .doc(event.id)
                                  .delete();
                              _loadFirestoreEvents();
                            }
                          }),
                    ),
                  ],
                ))),
        bottomNavigationBar:
            const CustomBottomNavBar(selectedMenu: MenuState.calandar));
  }
}
