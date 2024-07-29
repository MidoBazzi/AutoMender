import 'package:automender/Controllers/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:automender/Controllers/ExpertController.dart';
import '../../app_routes.dart';

class ExpLast extends StatelessWidget {
  ExpLast({super.key});
  final ExpertController expertController = Get.put(ExpertController());
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments;
    // Safely handle the case where 'message' is a list
    final List<dynamic> messages = arguments['message'];
    // Assuming you want to display the first message from the list
    final String finalMessage = messages.isNotEmpty
        ? messages.first.toString()
        : "No message available";

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Car Assistant',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 96, 62, 234),
          toolbarHeight: 100.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, 
              children: <Widget>[
                Image.asset(
                  'images/noun-mechanic.png',
                  height: 300.0,
                  width: 500,
                ),
                const SizedBox(height: 16),
                Text(
                  finalMessage, 
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                    fixedSize: const Size(350, 50),
                  ),
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.home);
                  },
                  child: const Text(
                    'Go back home',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
