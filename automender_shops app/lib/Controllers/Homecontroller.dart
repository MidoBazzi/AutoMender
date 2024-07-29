// ignore_for_file: file_names

import 'package:automender_shops/BackendUrl.dart';
import 'package:automender_shops/Controllers/TokenController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:automender_shops/model/userprofilee.dart';


class UserProfileController extends GetxController {
final AuthController authController = Get.find<AuthController>();


  var userProfile = UserProfile(
    email: '', 
  ownerName: '',
   locationX: '',
   shopName: '', 
   location: '',
    closeTime: 0,
     openTime: 0,
      locationY: '',
      schedule: '',
       phoneNum: '',
        picture: '',
         capacity: 2,
     ).obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchUserProfile();
    super.onInit();
  }

  void fetchUserProfile() async {
    isLoading(true);
    var response = await http.get(
      Uri.parse('${GlobalConfig.backendUrl}/auth_shop/user-profile'),
      headers: {
        'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
      },
    );
    if (response.statusCode == 200) {

      var jsonData = json.decode(response.body);
      userProfile(UserProfile.fromJson(jsonData['data']));
    } else {
        final responseData = json.decode(response.body);

        Get.snackbar('Login Failed', responseData['message']);
      }
    isLoading(false);
  }
}
