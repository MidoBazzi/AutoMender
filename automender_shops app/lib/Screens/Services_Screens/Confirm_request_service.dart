// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';
import 'package:automender_shops/Controllers/servicerequsetcontroller.dart';
import 'package:automender_shops/model/servicerequestmodel.dart';

class ConfirmRequestService extends StatelessWidget {
  const ConfirmRequestService({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceRequestController = Get.put(ServiceRequestController());
    final Map<String, String> requestData = Get.arguments;

      print('Received requestData: $requestData');

   ServiceRequest request = ServiceRequest(
  name: requestData['name'] ?? '', 
  desc: requestData['desc'] ?? '',
  price: requestData['price'] ?? '',
  time_req: requestData['time_req'] ?? '',
  
  
);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Confirm Requesting Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 96, 62, 234),
          toolbarHeight: 100.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Get.toNamed(AppRoutes.request_service);
            },
          ),
        ),
        body: SingleChildScrollView( 
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/Logo-shops.png',
                height: 200,
                width: 500,
              ),
              const SizedBox(height: 20),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Confirm Requesting Service',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildInfoRow('Service:', request.name),
                      const SizedBox(height: 8),
                      buildInfoRow('Description:', request.desc),
                      const SizedBox(height: 8),
                      buildInfoRow('Price:', request.price),
                      const SizedBox(height: 8),
                      buildInfoRow('Time Required:', request.time_req),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                        ),
                        onPressed: () {
                          serviceRequestController.sendServiceRequest(request);
                        },
                        child: const Text('Confirm',
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: const TextStyle(fontSize: 20)),
        Text(value, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
