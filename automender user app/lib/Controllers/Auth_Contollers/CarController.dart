// ignore_for_file: file_names, avoid_print

import 'package:automender/BackendUrl.dart';
import 'package:automender/Controllers/TokenController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarController {
  final AuthController authController = Get.find<AuthController>();
  Future<Map<String, dynamic>> getBrands() async {
    final response =
        await http.get(Uri.parse('${GlobalConfig.backendUrl}/user/get_brands'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load brands');
    }
  }

  Future<Map<String, dynamic>> getModels(int brandId) async {
    final response = await http
        .get(Uri.parse('${GlobalConfig.backendUrl}/user/get_models/$brandId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load models');
    }
  }

  Future<Map<String, dynamic>> getCountry(int brandId) async {
    final response = await http
        .get(Uri.parse('${GlobalConfig.backendUrl}/user/get_country/$brandId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load country');
    }
  }

  Future<void> addCar(Map<String, dynamic> carData) async {
    final response = await http.post(
        Uri.parse('${GlobalConfig.backendUrl}/user/add_car'),
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: {
          'country_id': carData['country_id'],
          'car_model_id': carData['model_id'],
          'brand_id': carData['brand_id'],
          'curr_mialage': carData['current_mileage'],
          'next_mialage': carData['next_oil_change_mileage'],
          'plate_num': carData['plate_number'],
          'color': carData['color'],
          'governorate': carData['governorate'],
          'email': carData['email'],
        });

    if (response.statusCode != 200) {
      throw Exception('Failed to add car');
    }
  }

  Future<void> deleteCar(int carId) async {
    final response = await http.get(
      Uri.parse('${GlobalConfig.backendUrl}/user/delete_car/$carId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authController.token}',
      },
    );

    if (response.statusCode != 200) {
      print('Failed to delete car. Status Code: ${response.statusCode}');
      throw Exception('Failed to delete car');
    }
  }

  Future<void> editCar(Map<String, dynamic> carData) async {
    final response = await http.post(
      Uri.parse('${GlobalConfig.backendUrl}/user/edit_car'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authController.token}',
      },
      body: {
        'curr_mialage': carData['curr_mialage'].toString(),
        'next_mialage': carData['next_mialage'].toString(),
        'plate_num': carData['plate_num'].toString(),
        'color': carData['color'],
        'governorate': carData['governorate'],
        'car_id': carData['car_id'].toString(),
      },
    );

    print("====================");
    print(response.statusCode);
    print(response.headers);
    print(response.body);
    print("====================");

    if (response.statusCode != 200) {
      
        final responseData = json.decode(response.body);

        Get.snackbar('Failed', responseData['message']);
      
    }
  }

  Future<void> editCurrMileage(Map<String, dynamic> carData) async {
    final response = await http.post(
      Uri.parse('${GlobalConfig.backendUrl}/user/edit_car'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authController.token}',
      },
      body: {
        'curr_mialage': carData['curr_mialage'].toString(),
        'car_id': carData['id'].toString(),
      },
    );

    print("====================");
    print(response.statusCode);
    print(response.headers);
    print(response.body);
    print("====================");

    if (response.statusCode != 200) {
    
        final responseData = json.decode(response.body);

        Get.snackbar('Login Failed', responseData['message']);
      
    }
  }
}
