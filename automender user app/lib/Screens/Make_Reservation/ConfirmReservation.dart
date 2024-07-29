// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';
import '../../Controllers/Appointment_Controllers/AppointmentController.dart';
import '../../model/appointment_model.dart';

class ConfirmReservation extends StatelessWidget {
  const ConfirmReservation({super.key});

  @override
  Widget build(BuildContext context) {
    Appointments? appointment; 
    appointment = Get.arguments['appointment'] as Appointments; 
    return MaterialApp(
      title: 'AutoMender Appointment Confirmation',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Confirm Appointment',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 96, 62, 234),
          toolbarHeight: 80.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30),
            onPressed: () => Get.back(result: {'appointment': appointment}),
          ),
        ),
        body: const ConfirmReservationScreen(),
      ),
    );
  }
}

class ConfirmReservationScreen extends StatelessWidget {
  const ConfirmReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Appointments appointment = Get.arguments['appointment'];
    final arguments = Get.arguments as Map<String, dynamic>;
    final String serviceName = arguments['serviceName'];
    final String shopName = arguments['shopName'];
    final AppointmentController appointmentController =
        Get.put(AppointmentController());

    void confirmAppointment() {
      appointmentController.makeAppointment(
        appointment.serviceId,
        appointment.ShopId,
        appointment.date,
        appointment.CarId,
        appointment.startTime,
      );
      Get.offAllNamed(AppRoutes.reservation_confirmed);
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Confirm your Appointment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _InfoSection(label: 'Shop', value: shopName),
            _InfoSection(label: 'Service', value: serviceName),
            _InfoSection(label: 'Date', value: appointment.date),
            _InfoSection(label: 'Time', value: appointment.startTime),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                  fixedSize: const Size(350, 50)),
              onPressed: confirmAppointment,
              child: const Text('Confirm',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _InfoSection({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 19)),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }
}
