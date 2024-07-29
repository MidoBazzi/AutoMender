// ignore_for_file: constant_identifier_names

import 'package:automender/model/car_model.dart';
import 'package:get/get.dart';
import 'Screens/Login_SignUp/login.dart';
import 'Screens/Login_SignUp/forget_password.dart';
import 'Screens/Login_SignUp/signup.dart';
import 'Screens/Onboarding/splash_screen.dart';
import 'Screens/Onboarding/onboard1.dart';
import 'Screens/Onboarding/onboard2.dart';
import 'Screens/Onboarding/onboard3.dart';
import 'Screens/Onboarding/onboard4.dart';
import 'Screens/Login_SignUp/static_help.dart';
import 'Screens/Home.dart';
import 'Screens/Login_SignUp/verifcation.dart';
import 'Screens/Login_SignUp/car_info.dart';
import 'Screens/Login_SignUp/account_created.dart';
import 'Screens/Make_Reservation/ChooseService.dart';
import 'Screens/EXPERT/beggin.dart';
import 'Screens/Manual_help.dart';
import 'Screens/UserProfile.dart';
import 'Screens/Make_Reservation/ChooseShop.dart';
import 'Screens/Make_Reservation/choose_date.dart';
import 'Screens/Make_Reservation/ConfirmReservation.dart';
import 'Screens/Make_Reservation/ReservationConfirmed.dart';
import 'Screens/Car_status.dart';
import 'Screens/EXPERT/ask.dart';
import 'Screens/EXPERT/last.dart';
import 'Screens/Home_add_car/home_add_car1.dart';
import 'Screens/Make_Reservation/map.dart';
import 'Screens/End_trip.dart';

class AppRoutes {
  static const String login = '/Screens/Login_SignUp/login';
  static const String forgotPassword = '/Screens/Login_SignUp/forgotPassword';
  static const String signUp = '/Screens/Login_SignUp/signUp';
  static const String splashscreen = '/Screens/Onboarding/splash_screen.dart';
  static const String board1 = '/Screens/Onboarding/onboard1.dart';
  static const String board2 = '/Screens/Onboarding/onboard2.dart';
  static const String board3 = '/Screens/Onboarding/onboard3.dart';
  static const String board4 = '/Screens/Onboarding/onboard4.dart';
  static const String statichelp = '/Screens/Login_SignUp/static_help';
  static const String home = '/Screens/Home';
  static const String verifcation = '/Screens/Login_SignUp/verifcation';
  static const String car_info1 = '/Screens/Login_SignUp/car_info1';

  static const String acc_created = '/Screens/Login_SignUp/account_created';
  static const String chooseservice = '/Screens/Make_Reservation/ChooseService';
  static const String exp_start = '/Screens/EXPERT/beggin';
  static const String manu_help = '/Screens/Manual_help';
  static const String userprofile = '/Screens/UserProfile';
  static const String chooseshop = '/Screens/Make_Reservation/ChooseShop';
  static const String choosedate = '/Screens/Make_Reservation/choose_date';
  static const String confirm_reservation =
      '/Screens/Make_Reservation/ConfirmReservation';
  static const String reservation_confirmed =
      '/Screens/Make_Reservation/ReservationConfirmed';
  static const String car_status = '/Screens/Car_status';
  static const String exp_ask = '/Screens/EXPERT/ask';
  static const String exp_last = '/Screens/EXPERT/last';
  static const String home_add_car1 = '/Screens/Home_add_car/home_add_car1';
  static const String map = '/Screens/Make_Reservation/map';
  static const String End_trip = '/Screens/End_trip';

  static final routes = [
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordPage()),
    GetPage(
        name: signUp,
        page: () => SignUpScreen(
            onVerificationPressed: () {})), 
    GetPage(name: splashscreen, page: () => const MySplashScreen()),
    GetPage(name: board1, page: () => const Onboard1()),
    GetPage(name: board2, page: () => const Onboard2()),
    GetPage(name: board3, page: () => const Onboard3()),
    GetPage(name: board4, page: () => const Onboard4()),
    GetPage(name: statichelp, page: () => const static_help()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: verifcation, page: () => VerificationPage()),
    GetPage(name: car_info1, page: () => const CarInfoForm()),

    GetPage(name: acc_created, page: () => const account_created()),
    GetPage(name: chooseservice, page: () => const choose_service()),
    GetPage(name: exp_start, page: () => expert_start()),
    GetPage(name: manu_help, page: () => const manual_help()),
    GetPage(name: userprofile, page: () => const Profile()),
    GetPage(name: chooseshop, page: () => const Choose_Shop()),
    GetPage(name: choosedate, page: () => const ServiceAppointmentScreen()),
    GetPage(name: confirm_reservation, page: () => const ConfirmReservation()),
    GetPage(name: reservation_confirmed, page: () => ReservationConfirmed()),
    GetPage(
        name: car_status,
        page: () {
          final Car2 selectedCar = Get.arguments['selectedCar'];
          return CarStatus(selectedCar: selectedCar);
        }),

    GetPage(name: exp_ask, page: () => ExpAsk()),
    GetPage(name: exp_last, page: () => ExpLast()),
    GetPage(name: home_add_car1, page: () => const CarInfoFormHome()),

    GetPage(name: map, page: () => const MapScreen()),
    GetPage(
        name: End_trip,
        page: () {
          final Car2 selectedCar = Get.arguments['car'];
          return Endtrip(car: selectedCar);
        }),
  ];
}
