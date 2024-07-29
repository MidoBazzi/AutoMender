import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';

class Onboard2 extends StatelessWidget {
  const Onboard2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 45),
            Image.asset(
              'images/Car repair.png',
              height: 300,
              width: 450,
            ),
            const Text(
              'Prioritize Your Car\'s Health',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                height: 3.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Schedule Regular Oil Changes\n and Services Automatically',
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
                  ),
                ),
                const Text(
                  '. ',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '.',
                  style: TextStyle(
                    fontSize: 45,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.board3);
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
