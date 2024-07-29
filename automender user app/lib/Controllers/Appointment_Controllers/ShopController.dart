// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:automender/BackendUrl.dart';
import 'package:automender/Controllers/TokenController.dart';
import 'package:automender/model/Shop_model.dart';

class ShopController extends GetxController {
  RxList<Shop> shops = <Shop>[].obs;
  final AuthController authController = Get.find<AuthController>();

  Future<void> fetchShops(String serviceId) async {
    try {
      final response = await http.get(
        Uri.parse('${GlobalConfig.backendUrl}/user/shops/$serviceId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is Map) {
          List<dynamic> shopsList = responseData['data']['shops'];
          shops.value = shopsList.map((shop) => Shop.fromMap(shop)).toList();
        } else {
          Get.snackbar('Error', 'Unexpected data format in data key',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Error',
            'Failed to load shops with status code: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
