// ignore_for_file: camel_case_types, library_private_types_in_public_api, file_names

import 'package:automender/Controllers/Appointment_Controllers/ServiceController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';

class choose_service extends StatefulWidget {
  const choose_service({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<choose_service> {
  final ServiceController serviceController = Get.put(ServiceController());
  String? carId;

  @override
  void initState() {
    super.initState();
    serviceController.fetchServices();
    if (Get.arguments != null && Get.arguments.containsKey('carId')) {
      carId = Get.arguments['carId'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Which service do you want',
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
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'images/service.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              color: const Color.fromARGB(132, 96, 62, 234),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                if (serviceController.services.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: serviceController.services.map((service) {
                      return Column(
                        children: [
                          TextButton(
                            onPressed: () => _onServiceClicked(
                                service.name, service.id.toString()),
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                            ),
                            child: Text(
                              service.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _onServiceClicked(String serviceName, String serviceId) {
    Get.toNamed(
      AppRoutes.chooseshop,
      arguments: {
        'carId': carId ?? '',
        'serviceId': serviceId,
        'serviceName': serviceName, 
      },
    );
  }
}
