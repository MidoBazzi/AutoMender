import 'package:automender_shops/Controllers/incoming_appointmen_contrroler.dart'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:automender_shops/app_routes.dart'; 

class IncomingCustomerPage extends StatelessWidget {
  final IncomingCustomerController controller = Get.put(IncomingCustomerController());

  IncomingCustomerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 62, 234),
        toolbarHeight: 100.0,
        title: const Text(
          'Incoming Customer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Get.toNamed(AppRoutes.home);
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: controller.appointments.length,
            itemBuilder: (context, index) {
              var appointment = controller.appointments[index];
              return Card(
                margin: const EdgeInsets.all(20.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Name: ${appointment.userName}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Divider(color: Colors.grey[400]), 
                      infoRow('Car:', '${appointment.carModel} ${appointment.carYear}'),
                      infoRow('Service:', appointment.serviceName),
                      infoRow('Date:', appointment.date),
                      infoRow('Start Time:', appointment.startTime),
                      infoRow('End Time:', appointment.endTime),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () => controller.denyAppointment(appointment.id),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                              child: IconButton(
                                icon: const Icon(Icons.check, color: Colors.white),
                                onPressed: () => controller.confirmAppointment(appointment.id),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }


  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

