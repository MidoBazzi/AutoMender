import 'package:automender/Controllers/ExpertController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpAsk extends StatelessWidget {
  ExpAsk({super.key});
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
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                'images/noun-mechanic.png',
                height: 300.0,
                width: 500,
              ),
              const SizedBox(height: 16),
              Obx(() => Text(
                    expertController.currentQuestion
                        .value, 
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 120, 22),
                      fixedSize: const Size(160, 50),
                    ),
                    onPressed: () {
                      expertController.sendAnswer(
                          'y'); 
                    },
                    child: const Text(
                      'yes',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      fixedSize: const Size(160, 50),
                    ),
                    onPressed: () {
                      expertController.sendAnswer(
                          'n'); 
                    },
                    child: const Text(
                      'no',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
