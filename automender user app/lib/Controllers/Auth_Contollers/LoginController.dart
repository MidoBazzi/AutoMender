// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:automender/Controllers/TokenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:automender/BackendUrl.dart';
import '../../app_routes.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  void updateEmailAndPassword() {
    email.value = emailController.text;
    password.value = passwordController.text;
  }


  Future<void> login() async {
    if (isLoading.value) return; 

    isLoading.value = true;
    var url = Uri.parse('${GlobalConfig.backendUrl}/auth/login');

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: {
          'email': email.value,
          'password': password.value,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final String accessToken = responseData['data']['access_token'];

        final authController = Get.find<AuthController>();
        await authController.saveToken(accessToken);

        Get.offAllNamed(AppRoutes.home);
      } else {
        final responseData = json.decode(response.body);

        Get.snackbar('Login Failed', responseData['message']);
      }
    } catch (error) {
      String errorMessage = "Unknown error occurred";
      if (error is SocketException) {
        errorMessage = "No Internet connection";
      } else if (error is HttpException) {
        errorMessage = "Couldn't find the server";
      } else if (error is FormatException) {
        errorMessage = "Bad response format";
      }
      Get.snackbar('Login Failed', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetPassword(String email) async {
    isLoading.value = true;

    var url = Uri.parse('${GlobalConfig.backendUrl}/password/email');

    try {
      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
        },
      );


      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password reset email sent successfully');
      } else {
        final responseData = json.decode(response.body);
        Get.snackbar('Failed', responseData['message']);
      }
    } catch (error) {
      Get.snackbar('Error', 'An error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
