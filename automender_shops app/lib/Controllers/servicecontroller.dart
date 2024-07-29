import 'package:automender_shops/BackendUrl.dart';
import 'package:automender_shops/Controllers/TokenController.dart';

import 'package:automender_shops/model/service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceController extends GetxController {
  var services = <Service>[].obs;
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

void fetchServices() async {
  var url = Uri.parse('${GlobalConfig.backendUrl}/shop/services');
  
 
    var response = await http.get(url,
    
    headers: {
        'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
      },
    
    );


  if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is Map) {
          Map<String, dynamic> data = responseData['data'];
          if (data.containsKey('services') && data['services'] is List) {
            List<dynamic> servicesList = data['services'];
            services.value = servicesList
                .map((service) => Service.fromJson(service))
                .toList();
          } else {
            Get.snackbar('Error', 'Unexpected data format in services key',
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('Error', 'Unexpected data format in data key',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        final responseData = json.decode(response.body);

        Get.snackbar('Login Failed', responseData['message']);
      }
    } 
  }

   
  



