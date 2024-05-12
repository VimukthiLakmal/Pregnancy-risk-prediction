import 'package:flutter/material.dart';

class ScreenOne extends StatelessWidget {
  final String text;
  final String text2;
  final String img;
  const ScreenOne({super.key, required this.text, required this.text2, required this.img});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(img),
        const SizedBox(height: 40),
        Text(
          text,
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
            text2,
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
