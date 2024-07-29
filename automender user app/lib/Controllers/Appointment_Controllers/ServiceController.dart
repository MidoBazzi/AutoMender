// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:automender/BackendUrl.dart';
import 'package:automender/Controllers/TokenController.dart';
import 'package:automender/model/service_model.dart';

class ServiceController extends GetxController {
  RxList<Service> services = <Service>[].obs;
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      final response = await http.get(
        Uri.parse('${GlobalConfig.backendUrl}/user/services'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is Map) {
          Map<String, dynamic> data = responseData['data'];
          if (data.containsKey('services') && data['services'] is List) {
            List<dynamic> servicesList = data['services'];
            services.value = servicesList
                .map((service) => Service.fromMap(service))
                .toList();
          } else {

            Get.snackbar('Error', 'Unexpected data format in services key',
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {

          Get.snackbar('Error', 'Unexpected data format in data key',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Error', 'Failed to load services',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
