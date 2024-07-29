// ignore_for_file: file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:convert';

import 'package:automender_shops/BackendUrl.dart';
import 'package:automender_shops/app_routes.dart';
import 'package:automender_shops/model/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController phoneNumberController = TextEditingController();
final TextEditingController newPasswordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
final TextEditingController shop_namecontroller = TextEditingController();
final TextEditingController locationcontroller = TextEditingController();


FileImage? shopimage;

Future<void> signUp({
required FileImage? image,
required Map<String, bool> selectedDays,
required String openingTime,
required String closingTime,
required String numberOfTeams,

required String locationX,
required String locationY,
}) async {
try {
 var schedule = selectedDays.keys.where(( key) => selectedDays[key]!).join(':');
shopimage = image;


  ShopModel shop = ShopModel(
    ownerName: nameController.text,
    shopName: shop_namecontroller.text,
    email: emailController.text,
    password: newPasswordController.text,
    phoneNum: phoneNumberController.text,
    location: locationcontroller.text,
    locationX: locationX,
    locationY: locationY,
    schedule: schedule,
    openTime: openingTime,
    closeTime: closingTime,
    capacity: numberOfTeams,
  );

String base64Image = '';
if (shopimage != null) {
  final bytes = await shopimage!.file.readAsBytes();

  String mimeType = 'image/jpeg'; 

  base64Image = 'data:$mimeType;base64,' + base64Encode(bytes);
}

print(base64Image);

  var response = await http.post(
    Uri.parse('${GlobalConfig.backendUrl}/auth_shop/register'),
   
    body: {
        'email':shop.email,
        'password':shop.password,
        'shop_name':shop.shopName,
        'phone_num':shop.phoneNum,
        'owner_name':shop.ownerName,
        'location_x':shop.locationX,
        'location_y':shop.locationY,
        'open_time':shop.openTime,
        'close_time':shop.closeTime,
        'capacity':shop.capacity,
        'schedule':shop.schedule,
        'location':shop.location,
        'picture':base64Image
        },
  );
print("=========================");
print(response.headers);
print(response.body);
print(response.statusCode);
print("=========================");


  if (response.statusCode == 201) {
    print('Signup successful');
    Get.toNamed(AppRoutes.veri, arguments: shop.email);
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
} catch (e) {
  print('Error occurred: $e');
}
}
}
