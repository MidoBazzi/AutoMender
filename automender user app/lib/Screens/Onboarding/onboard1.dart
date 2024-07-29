import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_routes.dart';

class Onboard1 extends StatelessWidget {
  const Onboard1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 45),
            Image.asset(
              'images/map-flatline.png',
              height: 300,
              width: 450,
            ),
            const Text(
              'Manage Your Trips',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                height: 3.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Accurate Mileage for \n Optimal Maintenance',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 120, 120, 120),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.board4);
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 150, 150, 150)),
                  ),
                ),
                const Spacer(),
                const Text(
                  '. ',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '. .',
                  style: TextStyle(
                    fontSize: 45,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.board2);
                  },
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 97, 62, 234)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
