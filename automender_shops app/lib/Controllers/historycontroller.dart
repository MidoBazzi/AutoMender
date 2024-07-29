// ignore_for_file: avoid_print

import 'package:automender_shops/BackendUrl.dart';
import 'package:automender_shops/crud/crud.dart';
import 'package:automender_shops/model/incoming_appointment_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryController extends GetxController {
  var isLoading = true.obs;
  var appointments = <Appointment>[].obs;

  @override
  void onInit() {
    fetchAppointments();
    super.onInit();
  }

  void fetchAppointments() async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('${GlobalConfig.backendUrl}/shop/history'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        var data =
            jsonData['data']; 
        if (data != null &&
            data is Map<String, dynamic> &&
            data.containsKey('appointments')) {
          var appointmentsData = data['appointments'];
          if (appointmentsData is List) {
            appointments.assignAll(
              appointmentsData.map((e) => Appointment.fromJson(e)).toList(),
            );
          }
        } else {
          print('Appointments data is null or not formatted correctly');
        }
      } else {
        final responseData = json.decode(response.body);

        Get.snackbar('Login Failed', responseData['message']);
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading(false);
    }
  }
}
