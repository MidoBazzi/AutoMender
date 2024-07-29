// ignore_for_file: file_names

import 'dart:convert';

import 'package:automender/BackendUrl.dart';
import 'package:automender/Controllers/TokenController.dart';
import 'package:automender/model/User_model.dart';
import 'package:automender/model/car_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  Rx<User> user = User(name: '', email: '', phoneNum: '').obs;
  RxList<Car2> cars = <Car2>[].obs;
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      final response = await http.get(
        Uri.parse('${GlobalConfig.backendUrl}/user/home'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        user.value = User.fromMap(data['user']);
        cars.value = List<Car2>.from(
          data['cars'].map((model) => Car2.fromMap(model)),
        );
      } else {}
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
