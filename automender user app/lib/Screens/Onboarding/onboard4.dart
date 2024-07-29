import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_routes.dart';

class Onboard4 extends StatelessWidget {
  const Onboard4({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'images/phone-maintenance.png',
              height: 300,
              width: 450,
            ),
            const Text(
              'Your Car Care Companion',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                height: 3.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Dive into a world of car care\n with our comprehensive\n suite of tools',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 120, 120, 120),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                  fixedSize: const Size(350, 15)),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('first_time', false);
                Get.offAllNamed(AppRoutes.login);
              },
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
