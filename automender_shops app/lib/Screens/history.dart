import 'package:automender_shops/Controllers/historycontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryPage extends StatelessWidget {
  final HistoryController controller = Get.put(HistoryController());

  HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointment History',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: const Color.fromARGB(255, 96, 62, 234),
        toolbarHeight: 80,
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.appointments.isEmpty) {
          return const Center(child: Text('No history records found.'));
        } else {
          return ListView.builder(
            itemCount: controller.appointments.length,
            itemBuilder: (context, index) {
              final appointment = controller.appointments[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          appointment.userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      rowInfo('Service:', appointment.serviceName),
                      rowInfo('Date:', appointment.date),
                      rowInfo('Time:',
                          '${appointment.startTime} - ${appointment.endTime}'),
                      rowInfo('Car:',
                          '${appointment.carModel} ${appointment.carYear}'),
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

  Widget rowInfo(String label, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(info, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
