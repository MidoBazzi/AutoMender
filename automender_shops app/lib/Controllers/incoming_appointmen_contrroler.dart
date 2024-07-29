// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:automender_shops/crud/crud.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:automender_shops/model/incoming_appointment_model.dart';
import 'package:automender_shops/BackendUrl.dart';

class IncomingCustomerController extends GetxController {
  var isLoading = RxBool(false);
  var appointments = RxList<Appointment>([]);

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    isLoading.value = true;
    final url = Uri.parse('${GlobalConfig.backendUrl}/shop/show_appointments');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var fetchedAppointments = (data['data']['appointments'] as List? ?? [])
            .map((e) => Appointment.fromJson(e))
            .toList();
        appointments.value = fetchedAppointments;
      } else {
        print('Failed to load appointments with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmAppointment(int id) async {
    final url = Uri.parse('${GlobalConfig.backendUrl}/shop/confirm_appointment/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        print('Appointment $id confirmed successfully.');
        fetchAppointments(); 
      } else {
        print('Failed to confirm appointment with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error confirming appointment: $e');
    }
  }

  Future<void> denyAppointment(int id) async {
    final url = Uri.parse('${GlobalConfig.backendUrl}/shop/deny_appointment/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        print('Appointment $id denied successfully.');
        fetchAppointments(); 
      } else {
        print('Failed to deny appointment with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error denying appointment: $e');
    }
  }
}

