// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:automender/model/question_answer.dart';
import 'package:get/get.dart';

import '../../app_routes.dart';


class static_help extends StatelessWidget {
  const static_help({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manual Help',
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
              Get.toNamed(AppRoutes.login);
            },
          ),
        ),
        body: const Center(child: ToggleContainer()),
      ),
    );
  }
}

class ToggleContainer extends StatefulWidget {
  const ToggleContainer({super.key});

  @override
  _ToggleContainerState createState() => _ToggleContainerState();
}

class _ToggleContainerState extends State<ToggleContainer> {
  late List<QnList> qnAPairs;
  late List<bool> isVisibleList;

  @override
  void initState() {
    super.initState();
    qnAPairs = QnAData.getQnAPairs();
    isVisibleList = List.generate(qnAPairs.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Image.asset(
              'images/Logo.png',
              height: 150,
            ),
            const Text(
              'Login to have access to our \ncar assistant',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 25),
            for (int i = 0; i < qnAPairs.length; i++)
              Card(
                margin: const EdgeInsets.only(bottom: 15),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        qnAPairs[i].question,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isVisibleList[i]
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            isVisibleList[i] = !isVisibleList[i];
                          });
                        },
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(isVisibleList[i] ? 16 : 0),
                      height: isVisibleList[i] ? null : 0,
                      child: Text(
                        qnAPairs[i].answer,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
