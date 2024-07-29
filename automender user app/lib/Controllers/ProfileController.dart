// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:automender/Controllers/TokenController.dart';
import 'package:automender/BackendUrl.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  var name = ''.obs;
  var email = ''.obs;
  var phoneNum = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    var url = Uri.parse('${GlobalConfig.backendUrl}/auth/user-profile');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authController.token}',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      name.value = jsonData['data']['name'];
      email.value = jsonData['data']['email'];
      phoneNum.value = jsonData['data']['phone_num'];
    } else {
    }
  }

  void updateProfile(
      String newName, String newPhone, String newPassword) async {
    var url = Uri.parse('${GlobalConfig.backendUrl}/user/edit_profile');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ${authController.token}',
        'Accept': 'application/json',
      },
      body: {
        'name': newName,
        'phone_num': newPhone,
        'password': newPassword,
      },
    );

    if (response.statusCode == 200) {
      name.value = newName;
      phoneNum.value = newPhone;
    } else {
    }
  }
}
