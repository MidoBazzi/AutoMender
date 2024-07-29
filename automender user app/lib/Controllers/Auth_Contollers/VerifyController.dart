// ignore_for_file: file_names, empty_catches

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:automender/BackendUrl.dart';

import '../../app_routes.dart';

class VerificationController extends GetxController {
  Future<void> verifyEmail(String email) async {
    try {
      final url = Uri.parse('${GlobalConfig.backendUrl}/email/check');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        Get.offAllNamed(AppRoutes.car_info1, arguments: email);
      } else {
        final responseData = json.decode(response.body);

        Get.snackbar('Login Failed', responseData['message']);
      }
    } catch (e) {
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      final url = Uri.parse('${GlobalConfig.backendUrl}/email/resend');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
      } else {
        final responseData = json.decode(response.body);

        Get.snackbar('Failed', responseData['message']);
      }
    } catch (e) {
    }
  }
}
