import 'package:flutter/material.dart';

//Snack Bar to display  messages
void snackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style:TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
    ),
  );
}
