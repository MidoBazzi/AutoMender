// ignore_for_file: file_names

import 'package:automender/Controllers/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_routes.dart';

class ReservationConfirmed extends StatelessWidget {
  ReservationConfirmed({super.key});
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Reservation Confirmed',
      home: ConfirmationScreen(),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/confirmedres.png'), 
            const Text('Your reservation was placed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Successfully!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                  fixedSize: const Size(350, 15)),
              onPressed: () {
                Get.offAllNamed(AppRoutes.home);
              },
              child: const Text(
                'Go to Home',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
