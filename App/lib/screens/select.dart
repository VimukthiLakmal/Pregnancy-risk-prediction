import 'package:flutter/material.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/top.png',
              width: 120,
            ),
          ),
          PageView(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/im4.png'),
                const SizedBox(height: 40),
                const Text(
                  'Select Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 40,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.pink,
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Pregnant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 40,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: const Color.fromARGB(255, 233, 30, 148),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registert');
                    },
                    child: const Text(
                      'Delivered',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ]),
        ]));
  }
}
