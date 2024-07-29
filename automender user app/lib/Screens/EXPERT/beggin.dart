// ignore_for_file: camel_case_types

import 'package:automender/Controllers/ExpertController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_routes.dart';

class expert_start extends StatelessWidget {
  expert_start({super.key});

  final ExpertController expertController = Get.put(ExpertController());
  @override
  Widget build(BuildContext context) {
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Get.toNamed(AppRoutes.home);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'images/noun-mechanic.png',
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to our car assistant. Do you have any mechanical problems?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                    fixedSize: const Size(350, 15),
                  ),
                  onPressed: () async {
                    await expertController
                        .startExpert(); 
                    Get.toNamed(
                        AppRoutes.exp_ask); 
                  },
                  child: const Text(
                    'continue',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
