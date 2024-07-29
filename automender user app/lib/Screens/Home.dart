// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print, deprecated_member_use, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:automender/Controllers/Auth_Contollers/CarController.dart';
import 'package:automender/Controllers/HomeController.dart';
import 'package:automender/Controllers/TokenController.dart';
import 'package:automender/model/User_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_routes.dart';
import '../model/Home_model.dart';
import '../model/car_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.find<HomeController>();
  Car2? selectedCar;

  @override
  void initState() {
    super.initState();
    Get.put(HomeController());
    Get.put(CarController());
    homeController.getUserInfo();
    if (homeController.cars.isNotEmpty) {
      selectedCar = homeController.cars.first;
    }
     Future.delayed(Duration.zero, () {
    checkAndShowOilChangeNotification();
  });
  }

  void onPressedButton1() {
    if (selectedCar != null) {
      Get.toNamed(
        AppRoutes.End_trip,
        arguments: {'car': selectedCar},
      );
    } 
  }

  void onPressedButton2() {
    if (selectedCar != null) {
      Get.toNamed(
        AppRoutes.chooseservice,
        arguments: {'carId': selectedCar!.id},
      );
    }
  }

  void onPressedButton3() {
    Get.toNamed(AppRoutes.exp_start);
  }

  void onPressedButton4() {
    Get.toNamed(AppRoutes.manu_help);
  }

  void onPressedButton5() {
    Get.toNamed(AppRoutes.userprofile);
  }

  void onPressedButton6() {
    Get.toNamed(AppRoutes.car_status, arguments: {'selectedCar': selectedCar});
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    print(authController.token);

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Obx(() {
                  var user = homeController.user.value;
                  return userInfoWidget(user);
                }),
                const SizedBox(height: 16),
                PhotoWithText(
                  imagePath: 'images/Car2.png',
                  buttonText: 'Start Trip',
                  onPressed: onPressedButton1,
                ),
                const SizedBox(height: 16),
                PhotoWithText(
                  imagePath: 'images/repair_shops.png',
                  buttonText: 'Service Shops',
                  onPressed: onPressedButton2,
                ),
                const SizedBox(height: 16),
                PhotoWithText(
                  imagePath: 'images/Car_status.png',
                  buttonText: 'Car Status',
                  onPressed: onPressedButton6,
                ),
                const SizedBox(height: 16),
                PhotoWithText(
                  imagePath: 'images/expert.png',
                  buttonText: 'Car Assistant',
                  onPressed: onPressedButton3,
                ),
                const SizedBox(height: 16),
                PhotoWithText(
                  imagePath: 'images/Manual-help.png',
                  buttonText: 'Manual Help',
                  onPressed: onPressedButton4,
                ),
                const SizedBox(height: 16),
                PhotoWithText(
                  imagePath: 'images/Profile.png',
                  buttonText: 'Profile',
                  onPressed: onPressedButton5,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ));
  }

  Widget userInfoWidget(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(158, 158, 158, 0.562),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello ${user.name}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: _openCarSelection,
                    child: Row(
                      children: [
                        Text(
                          selectedCar != null
                              ? '${selectedCar!.brandName} ${selectedCar!.carModelName}'
                              : 'Select a Car',
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.keyboard_arrow_down,
                            size: 30, color: Color.fromARGB(255, 96, 62, 234)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Image.asset('images/avatar.png', height: 100, width: 100),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text(
              'Do you want to exit the App?',
              style: TextStyle(fontSize: 18),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No', style: TextStyle(fontSize: 16)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        )) ??
        false;
  }

  void checkAndShowOilChangeNotification() {
  if (selectedCar == null) return;

  int currentMileage = selectedCar!.currMialage;
  int nextOilChangeMileage = selectedCar!.nextMialage;
print('mankoh');
  if ((5000 - (nextOilChangeMileage - currentMileage)) >= 4500) {
    Get.snackbar(
      'Oil Change Reminder',
      'It\'s almost time to change the oil for your ${selectedCar!.brandName} ${selectedCar!.carModelName}.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}


  void _openCarSelection() {
    var user = homeController.user.value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select or Delete a Car"),
          content: Obx(() {
            var cars = homeController.cars.value;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: cars.map((Car2 car) {
                return ListTile(
                  title: Text(
                    '${car.brandName} ${car.carModelName}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 24,
                    ),
                    onPressed: homeController.cars.length > 1
                        ? () async {
                            try {
                              await Get.find<CarController>().deleteCar(car.id);
                              homeController.cars
                                  .remove(car);
                              if (selectedCar == car) {
                                selectedCar =
                                    null;
                              }
                              setState(() {});
                              Navigator.of(context).pop();
                            } catch (e) {
                              print(e);
                              
                            }
                          }
                        : null,
                  ),
                  onTap: () {
                    setState(() {
                      selectedCar = car;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            );
          }),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 97, 62, 234),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.home_add_car1, arguments: user.email);
              },
              child: const Text(
                'Add car',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
