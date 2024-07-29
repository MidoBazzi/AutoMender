// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:automender/BackendUrl.dart';
import 'package:automender/Controllers/TokenController.dart';

class AppointmentController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  Future<List<String>> fetchDates(String shopId) async {
    List<String> dates = [];
    try {
      final response = await http.get(
        Uri.parse('${GlobalConfig.backendUrl}/user/get_dates/$shopId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is Map) {
          var data = responseData['data'];
          if (data.containsKey('dates') && data['dates'] is List) {
            dates =
                List<String>.from(data['dates'].map((date) => date['date']));
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to load dates',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    return dates;
  }

  Future<List<String>> fetchTimeSlots(
      String shopId, String serviceId, String date) async {
    List<String> timeSlots = [];
    try {
      final response = await http.post(
        Uri.parse('${GlobalConfig.backendUrl}/user/get_times'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
        body: {
          'service_id': serviceId,
          'shop_id': shopId,
          'date': date,
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is Map) {
          var data = responseData['data'];
          if (data.containsKey('slots') && data['slots'] is List) {
            timeSlots =
                List<String>.from(data['slots'].map((slot) => slot.toString()));
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to load time slots',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    return timeSlots;
  }

  Future<void> makeAppointment(String serviceId, String shopId, String date,
      String carId, String time) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalConfig.backendUrl}/user/make_appointment'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
        body: {
          'service_id': serviceId,
          'shop_id': shopId,
          'date': date,
          'car_id': carId,
          'time': time,
        },
      );

      if (response.statusCode == 200) {
      } else {
        Get.snackbar('Error', 'Failed to make an appointment',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
