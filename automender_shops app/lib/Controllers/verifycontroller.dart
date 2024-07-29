// ignore_for_file: file_names, empty_catches

import 'dart:convert';

import 'package:automender_shops/BackendUrl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../app_routes.dart';

class VerificationController extends GetxController {
  Future<void> verifyEmail(String email) async {
    try {
      final url = Uri.parse('${GlobalConfig.backendUrl}/shop/email/check');
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
        Get.toNamed(AppRoutes.account_created);
      } else {
        final responseData = json.decode(response.body);

        Get.snackbar('Login Failed', responseData['message']);
      }
    } catch (e) {
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      final url = Uri.parse('${GlobalConfig.backendUrl}/shop/email/resend');
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