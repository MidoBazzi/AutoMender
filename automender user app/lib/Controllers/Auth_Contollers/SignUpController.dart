// ignore_for_file: file_names, unused_element, non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:automender/BackendUrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../app_routes.dart';

class SignUpController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var ValidationError = ''.obs;

  Future<void> signUp() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    var url = Uri.parse('${GlobalConfig.backendUrl}/auth/register');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
      },
      body: {
        'name': nameController.text,
        'email': emailController.text,
        'phone_num': phoneNumberController.text,
        'password': newPasswordController.text,
      },
    );

    print("====================");
    print(response.statusCode);
    print(response.headers);
    print(response.body);
    print("====================");

    if (response.statusCode == 200) {
      Get.toNamed(AppRoutes.verifcation, arguments: emailController.text);
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
    Get.snackbar('Signup Failed', combinedErrorMessage);
  } else {
    Get.snackbar('Signup Failed', 'An unexpected error occurred');
  }
}

    @override
    void onClose() {
      nameController.dispose();
      emailController.dispose();
      phoneNumberController.dispose();
      newPasswordController.dispose();
      confirmPasswordController.dispose();
      super.onClose();
    }
  }
}
