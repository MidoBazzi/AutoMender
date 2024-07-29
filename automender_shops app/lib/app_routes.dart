// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'Screens/Login_SignUp/login.dart';
import 'Screens/Login_SignUp/forget_password.dart';
import 'Screens/Login_SignUp/signup.dart';
import 'Screens/Home.dart';
import 'Screens/Login_SignUp/verifcation.dart';
import 'Screens/Profile/ShopProfile.dart';
import 'Screens/Services_Screens/shop_add_service.dart';
import 'Screens/Services_Screens/request_service.dart';
import 'Screens/Services_Screens/Confirm_adding_service.dart';
import 'Screens/Services_Screens/add_service_confirmed.dart';
import 'Screens/Services_Screens/request_service_confirmed.dart';
import 'Screens/Login_SignUp/account_created.dart';
import 'Screens/incoming_rides.dart';
import 'Screens/Services_Screens/Confirm_request_service.dart';
import 'map/show_on_map.dart';
import 'Screens/history.dart';



class AppRoutes {
  static const String login = '/Screens/Login_SignUp/login';
  static const String forgotPassword = '/Screens/Login_SignUp/forgotPassword';
  static const String signUp = '/Screens/Login_SignUp/signUp';
  static const String home = '/Screens/Home';
  static const String veri = '/Screens/Login_SignUp/verifcation';
  static const String shop_profile = '/Screens/Profile/ShopProfile';
  static const String shop_add_ser =
      '/Screens/Services_Screens/shop_add_service';
  static const String request_service =
      '/Screens/Services_Screens/request_service';
  static const String confirm_add_ser =
      '/Screens/Services_Screens/Confirm_adding_service';
  static const String add_service_confirmed =
      '/Screens/Services_Screens/add_service_confirmed';
  static const String request_service_confirmed =
      '/Screens/Services_Screens/request_service_confirmed';
  static const String enter_shop_info = '/Screens/Login_SignUp/enter_shop_info';
  static const String account_created = '/Screens/Login_SignUp/account_created';
  static const String incoming_rides = '/Screens/incoming_rides';
  static const String confirm_req_ser =
      '/Screens/Services_Screens/Confirm_request_service';
  static const String show_on_map = '/show_on_map';
  static const String history = '/Screens/history';

  static final routes = [
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordPage()),
    GetPage(
        name: signUp, page: () => SignUpScreen(onVerificationPressed: () {})),
    GetPage(name: home, page: () => const ShopHomeScreen()),
    GetPage(name: veri, page: () => VerificationPage()),
    GetPage(name: shop_profile, page: () => const ShopProfileScreen()),
    GetPage(name: shop_add_ser, page: () => const ShopAddServiceScreen()),
    GetPage(name: request_service, page: () => const RequestServiceScreen()),
    GetPage(name: confirm_add_ser, page: () => const Confirm_adding_service()),
    GetPage(
        name: add_service_confirmed, page: () => const ConfirmationScreen()),
    GetPage(
        name: request_service_confirmed,
        page: () => const ConfirmationScreen2()),
   
    GetPage(name: account_created, page: () => const Account_Created()),
    GetPage(name: incoming_rides, page: () => IncomingCustomerPage()),
    GetPage(name: confirm_req_ser, page: () => const ConfirmRequestService()),
    GetPage(name: show_on_map, page: () => const Map()),
     GetPage(name: history, page: () =>   HistoryPage()),
  ];
}
