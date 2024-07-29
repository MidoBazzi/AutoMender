// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:automender_shops/Controllers/TokenController.dart';
import 'package:automender_shops/BackendUrl.dart';

class ShopController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  var ownerName = ''.obs;
  var shopName = ''.obs;
  var email = ''.obs;
  var phoneNum = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShopProfile();
  }

  void fetchShopProfile() async {
    var url = Uri.parse('${GlobalConfig.backendUrl}/auth_shop/user-profile');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authController.token}',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      ownerName.value = jsonData['data']['owner_name'];
      shopName.value = jsonData['data']['shop_name'];
      email.value = jsonData['data']['email'];
      phoneNum.value = jsonData['data']['phone_num'];
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
    Get.snackbar('fetching Failed', combinedErrorMessage);
  } else {
    Get.snackbar('fetching Failed', 'An unexpected error occurred');
  }
}
  }

  void updateShopProfile(String newOwnerName, String newShopName, String newPhone, String newPassword) async {
    var url = Uri.parse('${GlobalConfig.backendUrl}/shop/edit_profile');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ${authController.token}',
        'Accept': 'application/json',
      },
      body: {
        'owner_name': newOwnerName,
        'shop_name': newShopName,
        'phone_num': newPhone,
        'newpassword': newPassword,
      },
    );

    if (response.statusCode == 200) {
      ownerName.value = newOwnerName;
      shopName.value = newShopName;
      phoneNum.value = newPhone;

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
    Get.snackbar('updating Failed', combinedErrorMessage);
  } else {
    Get.snackbar('updating Failed', 'An unexpected error occurred');
  }
}
  }
}
