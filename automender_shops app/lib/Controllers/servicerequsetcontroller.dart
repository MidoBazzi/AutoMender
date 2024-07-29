// ignore_for_file: avoid_print

import 'package:automender_shops/BackendUrl.dart';
import 'package:automender_shops/Controllers/TokenController.dart';
import 'package:automender_shops/app_routes.dart';
import 'package:automender_shops/model/servicerequestmodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceRequestController extends GetxController {
  Future<void> sendServiceRequest(ServiceRequest request) async {
    final AuthController authController = Get.find<AuthController>();
    var url = Uri.parse('${GlobalConfig.backendUrl}/shop/request_service');

    var requestBody = jsonEncode(request.toJson());
    print('Sending request to $url with body: $requestBody');  

    try {
      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
          'Content-Type': 'application/json', 
        },
        body: requestBody,
      );

      print("=========================");
print(response.headers);
print(response.body);
print(response.statusCode);
print("=========================");


      if (response.statusCode == 200) {
        Get.offAllNamed(AppRoutes.request_service_confirmed);
        print('Request sent successfully');
      } else {
  final responseData = json.decode(response.body);
  if (responseData.containsKey('data')) {
    List<String> errorMessages = [];
    Map<String, dynamic> errors = responseData['data'];
    errors.forEach((field, messages) {
      String message = (messages as List).join(', ');
      errorMessages.add('$field: $message');
    });
    String combinedErrorMessage = errorMessages.join('\n');
    Get.snackbar('Failed', combinedErrorMessage);
  } else {
    Get.snackbar('Failed', 'An unexpected error occurred');
  }
}
    } catch (e) {
      print('Error sending request: $e');
    }
  }
}

